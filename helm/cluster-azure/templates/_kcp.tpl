{{- define "controlplane-azuremachinetemplate-spec" -}}
{{ $identity := dict "type" "controlPlane" "Values" $.Values "Release" $.Release }}
{{- include "renderIdentityConfiguration" $identity }}
image:
  computeGallery:
    gallery: {{  $.Values.internal.image.gallery }}
    name: {{ include "flatcarImageName" $ }}
    version: {{ $.Values.internal.image.version }}
dataDisks:
  - diskSizeGB: {{ $.Values.controlPlane.etcdVolumeSizeGB }}
    lun: 0
    nameSuffix: etcddisk
  - diskSizeGB: {{ $.Values.controlPlane.containerdVolumeSizeGB }}
    lun: 1
    nameSuffix: containerddisk
  - diskSizeGB: {{ $.Values.controlPlane.kubeletVolumeSizeGB }}
    lun: 2
    nameSuffix: kubeletdisk
osDisk:
  diskSizeGB: {{ $.Values.controlPlane.rootVolumeSizeGB }}
  osType: Linux
securityProfile:
  encryptionAtHost: {{ $.Values.controlPlane.encryptionAtHost }}
sshPublicKey: {{ include "fake-rsa-ssh-key" $ | b64enc }}
vmSize: {{ $.Values.controlPlane.instanceType }}
{{- if ( include "network.subnets.controlPlane.name" $ ) }}
subnetName: {{ include "network.subnets.controlPlane.name" $ }}
{{- end }}
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
      name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-azuremachinetemplate-spec" $) .) }}
  kubeadmConfigSpec:
    # Workaround for https://github.com/kubernetes-sigs/cluster-api/issues/7679.
    # Don't define partitions here, they are defined in "ignition.containerLinuxConfig.additionalConfig"
    diskSetup:
      filesystems:
      - device: /dev/disk/azure/scsi1/lun0
        extraOpts:
        - -E
        - lazy_itable_init=1,lazy_journal_init=1
        filesystem: ext4
        label: etcd_disk
        overwrite: false
      - device: /dev/disk/azure/scsi1/lun1
        extraOpts:
        - -E
        - lazy_itable_init=1,lazy_journal_init=1
        filesystem: ext4
        label: containerd_disk
        overwrite: false
      - device: /dev/disk/azure/scsi1/lun2
        extraOpts:
        - -E
        - lazy_itable_init=1,lazy_journal_init=1
        filesystem: ext4
        label: kubelet_disk
        overwrite: false
      #partitions:
      #- device: /dev/disk/azure/scsi1/lun0
      #  layout: true
      #  tableType: gpt
      #  overwrite: false
    mounts:
    - - etcd_disk
      - /var/lib/etcddisk
    - - containerd_disk
      - /var/lib/containerd
    - - kubelet_disk
      - /var/lib/kubelet
    format: ignition
    ignition:
      containerLinuxConfig:
        additionalConfig: |
          systemd:
            units:
            - name: kubeadm.service
              dropins:
              - name: 10-flatcar.conf
                contents: |
                  [Unit]
                  After=oem-cloudinit.service
            {{- if .Values.internal.teleport.enabled }}
            {{- include "teleportSystemdUnits" $ | nindent 12 }}
            {{- end }}
          # Workaround for https://github.com/kubernetes-sigs/cluster-api/issues/7679.
          # Filesystems is defined in `kubeadmConfigSpec.diskSetup` because without it the `mounts` section does not generate any mount unit
          storage:
            disks:
            - device: /dev/disk/azure/scsi1/lun0
              partitions:
              - number: 1
            #filesystems:
            #- name: etcd_disk
            #  mount:
            #    device: /dev/disk/azure/scsi1/lun0
            #    format: ext4
            #    label: etcd_disk
            #    path: /var/lib/etcddisk
            #    options:
            #    - -E
            #    - lazy_itable_init=1,lazy_journal_init=1
    clusterConfiguration:
      # Avoid accessibility issues (e.g. on private clusters) and potential future rate limits for the default `registry.k8s.io`
      imageRepository: gsoci.azurecr.io/giantswarm
      apiServer:
        certSANs:
          - 127.0.0.1
          - localhost
          - "api.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}"
          - "apiserver.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}"
        extraArgs:
          {{- if .Values.controlPlane.serviceAccountIssuer }}
          service-account-issuer: {{ .Values.controlPlane.serviceAccountIssuer }}
          {{- end }}
          cloud-provider: external
          cloud-config: /etc/kubernetes/azure.json
          {{- if .Values.controlPlane.oidc.issuerUrl }}
          {{- with .Values.controlPlane.oidc }}
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
          enable-admission-plugins: {{ include "enabled-admission-plugins" $ }}
          feature-gates: {{ include "enabled-feature-gates" $ }}
          kubelet-preferred-address-types: InternalIP
          profiling: "false"
          runtime-config: api/all=true,scheduling.k8s.io/v1alpha1=true
          service-account-lookup: "true"
          tls-cipher-suites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
          service-cluster-ip-range: {{ .Values.connectivity.network.serviceCidr }}
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
          terminated-pod-gc-threshold: "125"
          allocate-node-cidrs: "true"
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: external
          cluster-name: {{ include "resource.default.name" $ }}
          external-cloud-volume-plugin: azure
          feature-gates: {{ include "enabled-feature-gates" $ }}
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
        serviceSubnet: {{ .Values.connectivity.network.serviceCidr }}
    files:
    {{- include "oidcFiles" . | nindent 4 }}
    {{- if $.Values.internal.teleport.enabled }}
    {{- include "teleportFiles" . | nindent 4 }}
    {{- end }}
    {{- include "kubeletReservationFiles" $ | nindent 4 }}
    {{- include "commonSysctlConfigurations" $ | nindent 4 }}
    {{- include "auditRules99Default" $ | nindent 4 }}
    {{- include "containerdConfig" $ | nindent 4 }}
    - contentFrom:
        secret:
          key: control-plane-azure.json
          name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-azuremachinetemplate-spec" $) .) }}-azure-json
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
      skipPhases:
      - addon/coredns
      - addon/kube-proxy
      nodeRegistration:
        kubeletExtraArgs:
          azure-container-registry-config: /etc/kubernetes/azure.json
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: external
          eviction-soft: {{ .Values.internal.defaults.softEvictionThresholds }}
          eviction-soft-grace-period: {{ .Values.internal.defaults.softEvictionGracePeriod }}
          eviction-hard: {{ .Values.internal.defaults.hardEvictionThresholds }}
          eviction-minimum-reclaim: {{ .Values.internal.defaults.evictionMinimumReclaim }}
          protect-kernel-defaults: "true"
        name: '@@HOSTNAME@@'
        {{- if .Values.controlPlane.customNodeTaints }}
        taints:
        {{- include "customNodeTaints" .Values.controlPlane.customNodeTaints | indent 10 }}
        {{- end }}
    joinConfiguration:
      nodeRegistration:
        kubeletExtraArgs:
          azure-container-registry-config: /etc/kubernetes/azure.json
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: external
          eviction-soft: {{ .Values.internal.defaults.softEvictionThresholds }}
          eviction-soft-grace-period: {{ .Values.internal.defaults.softEvictionGracePeriod }}
          eviction-hard: {{ .Values.internal.defaults.hardEvictionThresholds }}
          eviction-minimum-reclaim: {{ .Values.internal.defaults.evictionMinimumReclaim }}
          protect-kernel-defaults: "true"
        name: '@@HOSTNAME@@'
        {{- if .Values.controlPlane.customNodeTaints }}
        taints:
        {{- include "customNodeTaints" .Values.controlPlane.customNodeTaints | indent 10 }}
        {{- end }}
    preKubeadmCommands:
    {{- include "prepare-varLibKubelet-Dir" . | nindent 6 }}
    {{- include "kubeletReservationPreCommands" . | nindent 6 }}
    {{- include "override-hostname-in-kubeadm-configuration" . | nindent 6 }}
    {{- include "override-pause-image-with-quay" . | nindent 6 }}
    {{- if (eq .Values.connectivity.network.mode "private") }}
    {{- include "kubeadm.controlPlane.privateNetwork.preCommands" . | nindent 6 }}
    {{- end }}
    {{- if (eq .Values.connectivity.network.mode "private") }}
    postKubeadmCommands:
    {{- include "kubeadm.controlPlane.privateNetwork.postCommands" . | nindent 6 }}
    {{- else }}
    postKubeadmCommands: []
    {{ end }}
  replicas: {{ .Values.controlPlane.replicas | default "3" }}
  version: {{ .Values.internal.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-azuremachinetemplate-spec" $) .) }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec: {{ include "controlplane-azuremachinetemplate-spec" $ | nindent 6 }}
{{- end -}}
