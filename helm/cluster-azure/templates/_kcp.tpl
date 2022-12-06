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
      name: {{ include "resource.default.name" $ }}-control-plane
  kubeadmConfigSpec:
    clusterConfiguration:
      apiServer:
        certSANs:
          - 127.0.0.1
          - localhost
        extraArgs:
          cloud-provider: external
          cloud-config: /etc/kubernetes/azure.json
          encryption-provider-config: /etc/kubernetes/encryption/config.yaml
        extraVolumes:
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
      - contentFrom:
          secret:
            key: control-plane-azure.json
            name: {{ include "resource.default.name" $ }}-control-plane-azure-json
        owner: root:root
        path: /etc/kubernetes/azure.json
        permissions: "0644"
      - path: /etc/kubernetes/encryption/config.yaml
        permissions: "0600"
        contentFrom:
          secret:
            name: {{ include "resource.default.name" $ }}-encryption-provider-config
            key: encryption
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
  replicas: {{ .Values.controlPlane.replicas }}
  version: {{ .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-control-plane
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      {{- if .Values.vmIdentity.type }}
      identity: {{ .Values.vmIdentity.type }}
      {{- if gt (len .Values.vmIdentity.userAssignedIdentitiesIds) 0 }}
      userAssignedIdentities:
      {{- range $id := .Values.vmIdentity.userAssignedIdentitiesIds }}
        - providerID: {{ $id }}
      {{- end }}
      {{- end }}
      {{- end }}
      dataDisks:
        - diskSizeGB: 256
          lun: 0
          nameSuffix: etcddisk
      osDisk:
        diskSizeGB: 128
        osType: Linux
      sshPublicKey: ""
      vmSize: Standard_D2s_v3
{{- end -}}