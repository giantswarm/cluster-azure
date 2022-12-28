{{- define "cluster" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    cluster.giantswarm.io/description: "{{ .Values.clusterDescription }}"
  labels:
    cluster-apps-operator.giantswarm.io/watching: ""
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  topology:
    class: marioc-clusterclass-v0.1.2
    version: v1.24.8
    controlPlane:
      replicas: 1
    workers:
      machineDeployments:
      - class: default-worker
        name: md-0
        replicas: 2
  clusterNetwork:
    services:
      cidrBlocks:
       - {{ .Values.network.serviceCIDR }}
    pods:
      cidrBlocks:
      - {{ .Values.network.podCIDR }}
{{- end -}}
