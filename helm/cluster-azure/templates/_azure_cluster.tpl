{{- define "azure-cluster" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureCluster
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  identityRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureClusterIdentity
    name: {{ .Values.azure.azureClusterIdentity.name }}
    namespace: {{ .Values.azure.azureClusterIdentity.namespace }}
  location: {{ .Values.azure.location }}
  networkSpec:
    subnets:
      - name: control-plane-subnet
        role: control-plane
      - name: node-subnet
        natGateway:
          name: node-natgateway
        role: node
    vnet:
      name: {{ include "resource.default.name" $ }}-vnet
  resourceGroup: {{ include "resource.default.name" $ }}
  subscriptionID: {{ .Values.azure.subscriptionId }}
{{ end }}
