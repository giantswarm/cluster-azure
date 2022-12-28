{{- define "azure-cluster" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureClusterTemplate
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: clusterclass-v0.1.0-control-plane
  namespace: {{ .Release.Namespace }}
spec:
  template:
    spec:
      identityRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AzureClusterIdentity
        name: cluster-identity
      location: {{ .Values.azure.location }}
      networkSpec:
        subnets:
          - name: control-plane-subnet
            role: control-plane
          - name: node-subnet
            natGateway:
              name: node-natgateway
            role: node
      subscriptionID: {{ .Values.azure.subsciptionID }}
{{ end }}
