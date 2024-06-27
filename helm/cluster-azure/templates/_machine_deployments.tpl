{{- define "machine-deployments" -}}
{{- range $nodePoolName, $nodePool := .Values.global.nodePools | default .Values.cluster.providerIntegration.workers.defaultNodePools }}
{{- $_ := set $ "nodePool" (dict "name" $nodePoolName "config" $nodePool) }}
{{- $kubernetesVersion := include "cluster.component.kubernetes.version" $ }}
{{- $osImageVersion := include "cluster.component.flatcar.version" $ }}
{{- $osImageVariant := include "cluster.component.flatcar.variant" $ }}
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
{{- end }}
{{- end -}}
