{{- define "machine-deployments" -}}
{{- range $nodePoolName, $nodePool := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
{{- $_ := set $ "nodePool" (dict "name" $nodePoolName "config" $nodePool) }}
{{- $_ := set $ "osImage" $.Values.cluster.providerIntegration.osImage }}
{{- $_ = set $ "kubernetesVersion" $.Values.cluster.providerIntegration.kubernetesVersion }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ $nodePoolName }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $nodePoolName }}-{{ include "cluster.data.hash" (dict "data" (include "machinedeployment-azuremachinetemplate-spec" $) "salt" $.Values.cluster.providerIntegration.hashSalt) }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      {{- include "machinedeployment-azuremachinetemplate-spec" $ | nindent 6}}
---
{{- if not .disableHealthChecks }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineHealthCheck
metadata:
  annotations:
    machine-deployment.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ $nodePoolName }}
  labels:
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ $nodePoolName }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $nodePoolName }}
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
      "cluster.x-k8s.io/deployment-name": {{ include "resource.default.name" $ }}-{{ $nodePoolName }}
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
