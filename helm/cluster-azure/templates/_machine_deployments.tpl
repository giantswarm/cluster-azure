{{- define "machine-deployments" -}}
{{- range $machineDeployment := .Values.machineDeployments }}
{{ $data := dict "spec" $machineDeployment "type" "machineDeployment" "Values" $.Values "Release" $.Release "Files" $.Files "Template" $.Template }}
{{ $kubeAdmConfigTemplateHash := dict "hash" ( include "hash" (dict "data" (include "machine-kubeadmconfig-spec" $data) "global" $) ) }}
{{ $azureMachineTemplateHash := dict "hash" ( include "hash" (dict "data" ( dict "spec" (include "machine-spec" $data) "identity" (include "machine-identity" $data) ) "global" $) ) }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  annotations:
    machine-deployment.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ .name }}
  labels:
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .replicas }}
  selector:
    matchLabels: null
  template:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $kubeAdmConfigTemplateHash.hash }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AzureMachineTemplate
        name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $azureMachineTemplateHash.hash }}
      version: {{ $.Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $azureMachineTemplateHash.hash }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      {{- include "machine-identity" $data | nindent 6}}
      {{- include "machine-spec" $data | nindent 6}}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  labels:
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}-{{ $kubeAdmConfigTemplateHash.hash }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec: {{- include "machine-kubeadmconfig-spec" (merge $data $azureMachineTemplateHash ) | nindent 6 }}
---
{{- end }}
{{- end -}}
