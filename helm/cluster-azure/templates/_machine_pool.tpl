{{- define "machinepool-azuremachinepool-spec" -}}
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
  sshPublicKey: {{ .global.sshSSOPublicKey | b64enc }}
  vmSize: {{ .machinePool.instanceType }}
{{- end -}}

{{- define "machinepool-kubeadmconfig-spec" -}}
nodeRegistration:
  kubeletExtraArgs:
    cloud-config: /etc/kubernetes/azure.json
    cloud-provider: external
  name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
{{- end }}

{{- define "machine-pools" -}}
{{- range $machinePool := .Values.machinePools }}
{{ $data := dict "machinePool" $machinePool "global" $.Values }}
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
          name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ include "hash" (dict "data" (include "machinepool-kubeadmconfig-spec" $) .) }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AzureMachinePool
        name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ include "hash" (dict "data" (include "machinepool-azuremachinepool-spec" $data ) .) }}
      version: {{ $.Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ include "hash" (dict "data" (include "machinepool-azuremachinepool-spec" $data ) .) }}
  namespace: {{ $.Release.Namespace }}
spec: {{ include "machinepool-azuremachinepool-spec" $data | nindent 2}}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ include "hash" (dict "data" (include "machinepool-kubeadmconfig-spec" $) .) }}
  namespace: {{ $.Release.Namespace }}
spec:
  joinConfiguration: {{ include "machinepool-kubeadmconfig-spec" $ | nindent 4 }}
    files:
    - contentFrom:
        secret:
          key: worker-node-azure.json
          name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ include "hash" (dict "data" (include "machinepool-kubeadmconfig-spec" $) .) }}-azure-json
      owner: root:root
      path: /etc/kubernetes/azure.json
      permissions: "0644"
---
{{- end }}
{{- end -}}
