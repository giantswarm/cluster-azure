{{- define "machinepool-azuremachinepool-spec" -}}
{{- if .Values.enablePerClusterIdentity -}}
identity: UserAssigned
userAssignedIdentities:
  - providerID: {{ include "vmUaIdentityPrefix" $ }}-nodes
  {{- if .Values.attachCapzControllerIdentity }}
  - providerID: {{ include "vmUaIdentityPrefix" $ }}-capz
  {{- end }}
{{ end -}}
location: {{ .machinePool.location }}
strategy:
  rollingUpdate:
    deletePolicy: Oldest
    maxSurge: 25%
    maxUnavailable: 1
  type: RollingUpdate
template:
  osDisk:
    diskSizeGB: {{ .machinePool.rootVolumeSizeGB }}
    managedDisk:
      storageAccountType: Premium_LRS
    osType: Linux
  sshPublicKey: {{ .Values.sshSSOPublicKey | b64enc }}
  vmSize: {{ .machinePool.instanceType }}
{{- end -}}

{{- define "machinepool-kubeadmconfig-spec" -}}
joinConfiguration:
  nodeRegistration:
    kubeletExtraArgs:
      cloud-config: /etc/kubernetes/azure.json
      cloud-provider: external
      eviction-soft: {{ .machinePool.softEvictionThresholds | default .Values.defaults.softEvictionThresholds }}
      eviction-soft-grace-period: {{ .machinePool.softEvictionGracePeriod | default .Values.defaults.softEvictionGracePeriod }}
      eviction-hard: {{ .machinePool.hardEvictionThresholds | default .Values.defaults.hardEvictionThresholds }}
      eviction-minimum-reclaim: {{ .Values.controlPlane.evictionMinimumReclaim | default .Values.defaults.evictionMinimumReclaim }}
      node-labels: role=worker,giantswarm.io/machine-pool={{ include "resource.default.name" $ }}-{{ .machinePool.name }}{{- if (gt (len .machinePool.customNodeLabels) 0) }},{{- join "," .machinePool.customNodeLabels }}{{- end }}
    name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
    {{- if .machinePool.customNodeTaints }}
    taints:
    {{- include "customNodeTaints" .machinePool.customNodeTaints | indent 6 }}
    {{- end }}
files:
  - contentFrom:
      secret:
        key: worker-node-azure.json
        name: {{ include "resource.default.name" $ }}-{{ .machinePool.name }}-azure-json
    owner: root:root
    path: /etc/kubernetes/azure.json
    permissions: "0644"
{{- include "kubeletReservationFiles" $ | nindent 2 }}
preKubeadmCommands:
{{- include "kubeletReservationPreCommands" . | nindent 2 }}
postKubeadmCommands: []
{{- end }}

{{- define "machine-pools" -}}
{{- range $machinePool := .Values.machinePools }}
{{ $data := dict "machinePool" $machinePool "Values" $.Values "Release" $.Release "Files" $.Files }}
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
spec: {{- include "machinepool-azuremachinepool-spec" $data | nindent 2}}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
{{- if $.Values.enableMachinePoolHashing }}
  annotations:
    "helm.sh/resource-policy": keep
{{- end }}
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec: {{- include "machinepool-kubeadmconfig-spec" $data | nindent 2 }}
---
{{- end }}
{{- end -}}
