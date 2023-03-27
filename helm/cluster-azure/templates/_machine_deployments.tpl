{{- define "machine-deployments" -}}
{{- range $nodePool := .Values.nodePools }}
{{ $thisNodePool := dict "spec" ( merge $nodePool ( dict  "type" "machineDeployment" ) ) "Values" $.Values "Release" $.Release "Files" $.Files "Template" $.Template }}
{{ $kubeAdmConfigTemplateHash := dict "hash" ( include "hash" (dict "data" (include "machine-kubeadmconfig-spec" $thisNodePool) "global" $) ) }}
{{ $azureMachineTemplateHash := dict "hash" ( include "hash" (dict "data" ( dict "spec" (include "machine-spec" $thisNodePool) "identity" (include "renderIdentityConfiguration" $thisNodePool) ) "global" $) ) }}
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
      version: {{ $.Values.internal.kubernetesVersion }}
      {{- if hasKey $nodePool "failureDomain" }}
      failureDomain: "{{ $nodePool.failureDomain }}"
      {{- end }}
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
      {{- include "renderIdentityConfiguration" $thisNodePool | nindent 6}}
      {{- include "machine-spec" $thisNodePool | nindent 6}}
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
    spec: {{- include "machine-kubeadmconfig-spec" (merge $thisNodePool $azureMachineTemplateHash ) | nindent 6 }}
---
{{- if not .disableHealthChecks }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineHealthCheck
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
  # (Optional) maxUnhealthy prevents further remediation if the cluster is already partially unhealthy
  maxUnhealthy: 40%
  # (Optional) nodeStartupTimeout determines how long a MachineHealthCheck should wait for
  # a Node to join the cluster, before considering a Machine unhealthy.
  nodeStartupTimeout: 10m
  # selector is used to determine which Machines should be health checked
  selector:
    matchLabels:
      "cluster.x-k8s.io/deployment-name": {{ include "resource.default.name" $ }}-{{ .name }}
  # Conditions to check on Nodes for matched Machines, if any condition is matched for the duration of its timeout, the Machine is considered unhealthy
  unhealthyConditions:
  - type: Ready
    status: Unknown
    timeout: 300s
  - type: Ready
    status: "False"
    timeout: 300s
{{- end }}
{{- end }}
{{- end -}}
