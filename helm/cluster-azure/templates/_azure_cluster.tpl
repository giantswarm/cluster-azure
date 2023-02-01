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
        cidrBlocks:
        - {{ .Values.network.controlPlane.cidr }}
      - name: node-subnet
        natGateway:
          name: {{ include "resource.default.name" $ }}-node-natgateway
          NatGatewayIP:
            name: {{ include "resource.default.name" $ }}-node-natgateway-ip
        role: node
        cidrBlocks:
        - {{ .Values.network.workers.cidr }}
    vnet:
      name: {{ include "resource.default.name" $ }}-vnet
      cidrBlocks:
      - {{ .Values.network.hostCIDR }}
      {{- if .Values.network.peerings }}
      peerings: {{ toYaml .Values.network.peerings | nindent 6 }}
      {{- end }}
    {{- if (eq .Values.network.mode "private") }}
    privateDNSZoneName: {{ .Values.network.privateDNSZoneName }}
    apiServerLB:
      name: {{ include "resource.default.name" $ }}-api-internal-lb
      type: Internal
      frontendIPs: {{ toYaml .Values.network.apiServer.frontendIPs | nindent 6 }}
    controlPlaneOutboundLB:
      name: {{ include "resource.default.name" $ }}-control-plane-outbound-lb
      type: Public
      frontendIPsCount: 1
    nodeOutboundLB:
      name: {{ include "resource.default.name" $ }}-node-outbound-lb
      type: Public
      frontendIPsCount: 1
    {{end}}
  resourceGroup: {{ include "resource.default.name" $ }}
  subscriptionID: {{ .Values.azure.subscriptionId }}
{{ end }}
