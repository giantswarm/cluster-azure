{{- define "controlplane-azuremachinetemplate-spec" -}}
template:
  metadata:
    labels:
      {{- include "labels.common" $ | nindent 8 }}
  spec:
    dataDisks:
      - diskSizeGB: 256
        lun: 0
        nameSuffix: etcddisk
    osDisk:
      diskSizeGB: 128
      osType: Linux
    sshPublicKey: {{ $.Values.sshSSOPublicKey | b64enc}}
    vmSize: {{ $.Values.controlPlane.instanceType }}
{{- end }}

{{- define "control-plane" }}
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlane
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ $.Release.Namespace }}
spec:
  machineTemplate:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    infrastructureRef:
      apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
      kind: AzureMachineTemplate
      name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-azuremachinetemplate-spec" $) "global" .) }}
  kubeadmConfigSpec:
    clusterConfiguration:
      apiServer:
        certSANs:
          - 127.0.0.1
          - localhost
        extraArgs:
          {{- if .Values.controlPlane.serviceAccountIssuer }}
          service-account-issuer: {{ .Values.controlPlane.serviceAccountIssuer }}
          {{- end }}
          cloud-provider: external
          cloud-config: /etc/kubernetes/azure.json
          {{- if .Values.oidc.issuerUrl }}
          {{- with .Values.oidc }}
          oidc-issuer-url: {{ .issuerUrl }}
          oidc-client-id: {{ .clientId }}
          oidc-username-claim: {{ .usernameClaim }}
          oidc-groups-claim: {{ .groupsClaim }}
          {{- if ne .caPem "" }}
          oidc-ca-file: /etc/ssl/certs/oidc.pem
          {{- end }}
          {{- end }}
          {{- end }}
          audit-log-maxage: "30"
          audit-log-maxbackup: "30"
          audit-log-maxsize: "100"
          audit-log-path: /var/log/apiserver/audit.log
          audit-policy-file: /etc/kubernetes/policies/audit-policy.yaml
          encryption-provider-config: /etc/kubernetes/encryption/config.yaml
          enable-admission-plugins: NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,DefaultStorageClass,PersistentVolumeClaimResize,Priority,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook
          feature-gates: TTLAfterFinished=true
          kubelet-preferred-address-types: InternalIP
          profiling: "false"
          runtime-config: api/all=true,scheduling.k8s.io/v1alpha1=true
          service-account-lookup: "true"
          tls-cipher-suites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
          service-cluster-ip-range: {{ .Values.network.serviceCIDR }}
        extraVolumes:
        - name: auditlog
          hostPath: /var/log/apiserver
          mountPath: /var/log/apiserver
          readOnly: false
          pathType: DirectoryOrCreate
        - name: policies
          hostPath: /etc/kubernetes/policies
          mountPath: /etc/kubernetes/policies
          readOnly: false
          pathType: DirectoryOrCreate
        - name: encryption
          hostPath: /etc/kubernetes/encryption
          mountPath: /etc/kubernetes/encryption
          readOnly: false
          pathType: DirectoryOrCreate
        - hostPath: /etc/kubernetes/azure.json
          mountPath: /etc/kubernetes/azure.json
          name: cloud-config
          readOnly: true
        timeoutForControlPlane: 20m
      controllerManager:
        extraArgs:
          authorization-always-allow-paths: "/healthz,/readyz,/livez,/metrics"
          bind-address: "0.0.0.0"
          logtostderr: "true"
          profiling: "false"
          allocate-node-cidrs: "true"
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: external
          cluster-name: {{ include "resource.default.name" $ }}
          external-cloud-volume-plugin: azure
          feature-gates: "CSIMigrationAzureDisk=true,TTLAfterFinished=true"
        extraVolumes:
          - hostPath: /etc/kubernetes/azure.json
            mountPath: /etc/kubernetes/azure.json
            name: cloud-config
            readOnly: true
      scheduler:
        extraArgs:
          authorization-always-allow-paths: "/healthz,/readyz,/livez,/metrics"
          bind-address: "0.0.0.0"
      etcd:
        local:
          dataDir: /var/lib/etcddisk/etcd
          extraArgs:
            listen-metrics-urls: "http://0.0.0.0:2381"
            quota-backend-bytes: "8589934592"
      networking:
        serviceSubnet: {{ .Values.network.serviceCIDR }}
    diskSetup:
      filesystems:
        - device: /dev/disk/azure/scsi1/lun0
          extraOpts:
            - -E
            - lazy_itable_init=1,lazy_journal_init=1
          filesystem: ext4
          label: etcd_disk
        - device: ephemeral0.1
          filesystem: ext4
          label: ephemeral0
          replaceFS: ntfs
      partitions:
        - device: /dev/disk/azure/scsi1/lun0
          layout: true
          overwrite: false
          tableType: gpt
    files:
    {{- include "oidcFiles" . | nindent 4 }}
    {{- include "sshFiles" . | nindent 4 }}
    - contentFrom:
        secret:
          key: control-plane-azure.json
          name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-azuremachinetemplate-spec" $) "global" .) }}-azure-json
      owner: root:root
      path: /etc/kubernetes/azure.json
      permissions: "0644"
    - path: /etc/kubernetes/encryption/config.yaml
      permissions: "0600"
      contentFrom:
        secret:
          name: {{ include "resource.default.name" $ }}-encryption-provider-config
          key: encryption
    - path: /etc/kubernetes/policies/audit-policy.yaml
      permissions: "0600"
      encoding: base64
      content: {{ $.Files.Get "files/etc/kubernetes/policies/audit-policy.yaml" | b64enc }}
    initConfiguration:
      nodeRegistration:
        kubeletExtraArgs:
          azure-container-registry-config: /etc/kubernetes/azure.json
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: external
          feature-gates: CSIMigrationAzureDisk=true
        name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
    joinConfiguration:
      nodeRegistration:
        kubeletExtraArgs:
          azure-container-registry-config: /etc/kubernetes/azure.json
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: external
          feature-gates: CSIMigrationAzureDisk=true
        name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
    mounts:
      - - LABEL=etcd_disk
        - /var/lib/etcddisk
    postKubeadmCommands: []
    preKubeadmCommands: []
  replicas: {{ .Values.controlPlane.replicas | default "3" }}
  version: {{ .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-azuremachinetemplate-spec" $) "global" .) }}
  namespace: {{ $.Release.Namespace }}
spec: {{ include "controlplane-azuremachinetemplate-spec" $ | nindent 2 }}
{{- end -}}