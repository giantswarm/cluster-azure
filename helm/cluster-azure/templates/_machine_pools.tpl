{{- define "machine-pools" }}
{{ range .Values.machinePools }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachinePool
metadata:
  annotations:
    machine-pool.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ .name }}
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .minSize }}
  template:
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfig
          name: {{ include "resource.default.name" $ }}-{{ .name }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AzureMachinePool
        name: {{ include "resource.default.name" $ }}-{{ .name }}
      version: {{ $.Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  additionalTags:
    "cluster-autoscaler-enabled": "true"
    "cluster-autoscaler-name": "{{ include "resource.default.name" $ }}"
    "min": "{{ .minSize }}"
    "max": "{{ .maxSize }}"
  identity: SystemAssigned
  location: ""
  strategy:
    rollingUpdate:
      deletePolicy: Oldest
      maxSurge: 25%
      maxUnavailable: 1
    type: RollingUpdate
  template:
    osDisk:
      diskSizeGB: 30
      managedDisk:
        storageAccountType: Premium_LRS
      osType: Linux
    sshPublicKey: ""
    terminateNotificationTimeout: 15
    vmSize: Standard_D4s_v3 
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  joinConfiguration:
    discovery: {}
    nodeRegistration:
      kubeletExtraArgs:
        azure-container-registry-config: /etc/kubernetes/azure.json
        cloud-config: /etc/kubernetes/azure.json
        cloud-provider: azure
        healthz-bind-address: 0.0.0.0
        image-pull-progress-deadline: 1m
        node-labels: role=worker,giantswarm.io/machine-pool={{ include "resource.default.name" $ }}-{{ .name }},{{- join "," .customNodeLabels }}
        v: "2"
      name: '{{ `{{ ds.meta_data["local_hostname"] }}` }}'
  preKubeadmCommands:
  - systemctl restart sshd
  files:
  - contentFrom:
      secret:
        key: worker-node-azure.json
        name: {{ include "resource.default.name" $ }}-azure-json
    owner: root:root
    path: /etc/kubernetes/azure.json
    permissions: "0644"
  {{- include "sshFiles" $ | nindent 2 }}
  users:
  {{- include "sshUsers" . | nindent 2 }}
---
{{ end }}
{{- end -}}
