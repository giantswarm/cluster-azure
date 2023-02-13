{{- define "machine-pools" -}}
{{- range $machinePool := .Values.machinePools }}
{{ $data := dict "spec" $machinePool "type" "machinePool" "Values" $.Values "Release" $.Release "Files" $.Files "Template" $.Template }}
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
      version: {{ $.Values.internal.kubernetesVersion }}
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
  {{- include "machine-identity" $data | nindent 2}}
  location: {{ $data.spec.location }}
  strategy:
    rollingUpdate:
      deletePolicy: Oldest
      maxSurge: 25%
      maxUnavailable: 1
    type: RollingUpdate
  template: {{- include "machine-spec" $data | nindent 4}}

---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec: {{- include "machine-kubeadmconfig-spec" $data | nindent 2 }}
---
{{- end }}
{{- end -}}
