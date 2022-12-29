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
    name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
files:
- contentFrom:
    secret:
      key: worker-node-azure.json
      name: {{ include "resource.default.name" $ }}-{{ .machinePool.name }}-{{ .mpHash }}-azure-json
  owner: root:root
  path: /etc/kubernetes/azure.json
  permissions: "0644"
{{- end }}

{{- define "machine-pools" -}}
{{- range $machinePool := .Values.machinePools }}
{{ $data := dict "machinePool" $machinePool "Values" $.Values "Release" $.Release }}
{{ $mpHash := ( include "hash" (dict "data" ( dict (include "machinepool-kubeadmconfig-spec" $data) (include "machinepool-azuremachinepool-spec" $data) ) .) ) }}
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
          name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $mpHash }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AzureMachinePool
        name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $mpHash }}
      version: {{ $.Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $mpHash }}
  namespace: {{ $.Release.Namespace }}
spec: {{- include "machinepool-azuremachinepool-spec" $data | nindent 2}}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
  annotations:
    "helm.sh/resource-policy": keep
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $mpHash }}
  namespace: {{ $.Release.Namespace }}
spec: {{- include "machinepool-kubeadmconfig-spec" (merge $data ( dict "mpHash" $mpHash ) )  | nindent 2 }}
---
{{- end }}
{{- end -}}
