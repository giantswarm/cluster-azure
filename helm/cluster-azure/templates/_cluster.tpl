{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    cluster.giantswarm.io/description: "{{ .Values.metadata.description }}"
  labels:
    cluster-apps-operator.giantswarm.io/watching: ""
    {{- if .Values.metadata.servicePriority }}
    giantswarm.io/service-priority: {{ .Values.metadata.servicePriority }}
    {{- end }}
    {{- if .Values.global.podSecurityStandards.enforced }}
    policy.giantswarm.io/psp-status: disabled
    {{- end }}
    {{- include "labels.common" $ | nindent 4 }}
    {{- if .Values.metadata.labels }}
    {{- range $key, $val := .Values.metadata.labels }}
    {{ $key }}: {{ $val | quote }}
    {{- end }}
    {{- end }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  clusterNetwork:
    services:
      cidrBlocks:
       - {{ .Values.connectivity.network.serviceCidr }}
    pods:
      cidrBlocks:
      - {{ .Values.connectivity.network.podCidr }}
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: KubeadmControlPlane
    name: {{ include "resource.default.name" $ }}
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureCluster
    name: {{ include "resource.default.name" $ }}
{{- end -}}
