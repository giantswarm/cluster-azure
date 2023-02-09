{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    cluster.giantswarm.io/description: "{{ .Values.metadata.description }}"
  labels:
    cluster-apps-operator.giantswarm.io/watching: ""
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  clusterNetwork:
    services:
      cidrBlocks:
       - {{ .Values.network.serviceCIDR }}
    pods:
      cidrBlocks:
      - {{ .Values.network.podCIDR }}
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: KubeadmControlPlane
    name: {{ include "resource.default.name" $ }}
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureCluster
    name: {{ include "resource.default.name" $ }}
{{- end -}}
