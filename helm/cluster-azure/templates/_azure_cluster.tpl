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
    name: {{ .Values.providerSpecific.azureClusterIdentity.name }}
    namespace: {{ .Values.providerSpecific.azureClusterIdentity.namespace }}
  location: {{ .Values.providerSpecific.location }}
  networkSpec:
    subnets:
      - name: control-plane-subnet
        role: control-plane
        cidrBlocks:
        - {{ .Values.connectivity.network.controlPlane.cidr }}
      - name: node-subnet
        natGateway:
          name: {{ include "resource.default.name" $ }}-node-natgateway
          NatGatewayIP:
            name: {{ include "resource.default.name" $ }}-node-natgateway-ip
        role: node
        cidrBlocks:
        - {{ .Values.connectivity.network.workers.cidr }}
    vnet:
      name: {{ include "resource.default.name" $ }}-vnet
      cidrBlocks:
      - {{ .Values.connectivity.network.hostCidr }}
      {{- if .Values.providerSpecific.network.peerings }}
      peerings: {{ toYaml .Values.providerSpecific.network.peerings | nindent 6 }}
      {{- end }}
    {{- if (eq .Values.connectivity.network.mode "private") }}
    privateDNSZoneName: {{ .Values.internal.privateDNSZoneName }}
    apiServerLB:
      name: {{ include "resource.default.name" $ }}-api-internal-lb
      type: Internal
      frontendIPs:
      - name: {{ include "resource.default.name" $ }}-api-internal-lb-ip
        privateIP: {{ .Values.connectivity.network.controlPlane.apiServerLbIp }}
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
  subscriptionID: {{ .Values.providerSpecific.subscriptionId }}
{{ end }}
