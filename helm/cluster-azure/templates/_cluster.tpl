{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    cluster.giantswarm.io/description: "{{ .Values.global.metadata.description }}"
  labels:
    cluster-apps-operator.giantswarm.io/watching: ""
    {{- if .Values.global.metadata.servicePriority }}
    giantswarm.io/service-priority: {{ .Values.global.metadata.servicePriority }}
    {{- end }}
    {{- if .Values.global.podSecurityStandards.enforced }}
    policy.giantswarm.io/psp-status: disabled
    {{- end }}
    {{- include "labels.common" $ | nindent 4 }}
    {{- if .Values.global.metadata.labels }}
    {{- range $key, $val := .Values.global.metadata.labels }}
    {{ $key }}: {{ $val | quote }}
    {{- end }}
    {{- end }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  clusterNetwork:
    services:
      cidrBlocks:
      {{- toYaml $.Values.global.connectivity.network.services.cidrBlocks | nindent 8 }}
    pods:
      cidrBlocks:
      {{- toYaml $.Values.global.connectivity.network.pods.cidrBlocks | nindent 8 }}
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: KubeadmControlPlane
    name: {{ include "resource.default.name" $ }}
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureCluster
    name: {{ include "resource.default.name" $ }}
{{- end -}}
