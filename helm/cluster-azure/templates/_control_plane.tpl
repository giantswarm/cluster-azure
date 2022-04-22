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
        extraArgs:
          cloud-provider: azure
          cloud-config: /etc/kubernetes/azure.json
          audit-log-maxage: "30"
          audit-log-maxbackup: "30"
          audit-log-maxsize: "100"
          audit-log-path: /var/log/apiserver/audit.log
          audit-policy-file: /etc/kubernetes/policies/audit-policy.yaml
          encryption-provider-config: /etc/kubernetes/encryption/config.yaml
          enable-admission-plugins: NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,DefaultStorageClass,PersistentVolumeClaimResize,Priority,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,PodSecurityPolicy
          feature-gates: TTLAfterFinished=true
          kubelet-preferred-address-types: InternalIP
          profiling: "false"
          runtime-config: api/all=true,scheduling.k8s.io/v1alpha1=true
          service-account-lookup: "true"
          tls-cipher-suites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
          service-cluster-ip-range: {{ .Values.network.serviceCIDR }}
        extraVolumes:
        - hostPath: /etc/kubernetes/azure.json
          mountPath: /etc/kubernetes/azure.json
          name: cloud-config
          readOnly: true
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
        timeoutForControlPlane: 20m0s    
      controllerManager:
        extraArgs:
          allocate-node-cidrs: "true"
          bind-address: 0.0.0.0
          cloud-provider: azure
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: azure
          cluster-name: {{ include "resource.default.name" $ }}
        extraVolumes:
        - hostPath: /etc/kubernetes/azure.json
          mountPath: /etc/kubernetes/azure.json
          name: cloud-config
          readOnly: true
      scheduler:
        extraArgs:
          bind-address: 0.0.0.0
      etcd:
        local:
            dataDir: /var/lib/etcddisk/etcd
          extraArgs:
            quota-backend-bytes: "8589934592"
      networking: {}
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
    {{- include "sshFiles" . | nindent 4 }}
    {{- include "kubernetesFiles" . | nindent 4 }}
    initConfiguration:
      localAPIEndpoint:
        advertiseAddress: ""
        bindPort: 0
      nodeRegistration:
        kubeletExtraArgs:
          azure-container-registry-config: /etc/kubernetes/azure.json
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: azure
          healthz-bind-address: 0.0.0.0
          image-pull-progress-deadline: 1m
          node-ip: '{{ `{{ ds.meta_data.local_ipv4 }}` }}'
          v: "2"
        name: '{{ `{{ ds.meta_data["local_hostname"] }}` }}'
    joinConfiguration:
      discovery: {}
      nodeRegistration:
        kubeletExtraArgs:
          azure-container-registry-config: /etc/kubernetes/azure.json
          cloud-config: /etc/kubernetes/azure.json
          cloud-provider: azure
        name: '{{ `{{ ds.meta_data["local_hostname"] }}` }}'
    mounts:
    - - LABEL=etcd_disk
      - /var/lib/etcddisk
    preKubeadmCommands:
    - systemctl restart ssh
    users:
    {{- include "sshUsers" . | nindent 4 }}
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
        cluster.x-k8s.io/role: control-plane
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      dataDisks:
      - cachingType: ReadWrite
        diskSizeGB: {{ .Values.controlPlane.etcdVolumeSizeGB }}
        lun: 0
        nameSuffix: etcddisk
      identity: None
      osDisk:
        cachingType: None
        diskSizeGB: {{ .Values.controlPlane.rootVolumeSizeGB }}
        osType: Linux
      sshPublicKey: c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCQVFEZHIrb0xVbHVJNmFRZW53d3V3S2M2dnI4Y1BDdnFBTk9mYmF3dmU2b3I0N2l1U3ZBdys2YXFyZFZTSEdkVmVNM2NJVnJSVk5KZUFpeHhwTE5vVVNzQWdvOG5TdzNGNWRMNlZ3RUtmaEZqR2V4cTlNK0tPRlZOUklnTm15NFQ2YWE3Y2xJREF5b3BHN1hVOGhIcnRhNmtYZS9ocko3OGlrUmsrZWtNcU9HaUltZEhLYkVsd1VqMWx2Yk00Qi8xM00yTTM0MGFROGZUWm5SU0RvWG5ETGUvS1hsODNZVWdIbkhsMzJWUktTVEtUU21tWWtEbWVXWFNNZzRaY2F0UmNudE9XYTJwT1V2OHU2YmsrK1NzeU9KbElTYjd2WXNRaEM2dTRSNXNzOWQ2QmVLd3kzWDVMWHVrd0pkbWRMaDRSSXNtMUZHaVh5WGNmYWE2U3hOT281M0QK
      vmSize: {{ .Values.controlPlane.vmSize }}
{{- end -}}
