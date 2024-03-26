{{- define "azure-cluster" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureCluster
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  {{- include "additional-tags" (dict "tags" .Values.providerSpecific.additionalResourceTags) | indent 2}}
  identityRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureClusterIdentity
    name: {{ .Values.providerSpecific.azureClusterIdentity.name }}
    namespace: {{ .Values.providerSpecific.azureClusterIdentity.namespace }}
  location: {{ .Values.providerSpecific.location }}
  networkSpec:
    subnets:
      - name: {{ include "network.subnets.controlPlane.name" $ }}
        role: control-plane
        cidrBlocks:
        - {{ .Values.connectivity.network.controlPlane.cidr }}
        {{- include "network.subnet.privateEndpoints" (dict "location" .Values.providerSpecific.location "endpoints" .Values.connectivity.network.controlPlane.privateEndpoints) | nindent 8 -}}
        securityGroup:
          name: {{ include "resource.default.name" $ }}-controlplane-nsg
          securityRules:
        {{- if (gt (len .Values.connectivity.allowedCIDRs) 0) }}
        {{- include "controlPlaneSecurityGroups" .Values.connectivity.allowedCIDRs | nindent 12 }}
        {{- else }}
           - name: "allow_ssh_from_all"
             description: "allow SSH"
             direction: "Inbound"
             priority: 148
             protocol: "*"
             destination: "*"
             destinationPorts: "22"
             source: "*"
             sourcePorts: "*"
           - name: "allow_apiserver_from_all"
             description: "Allow K8s API Server"
             direction: "Inbound"
             priority: 149
             protocol: "*"
             destination: "*"
             destinationPorts: "6443"
             source: "*"
             sourcePorts: "*"
        {{- end }}
      - name: {{ include "network.subnets.nodes.name" $ }}
        natGateway:
          name: {{ include "network.subnets.nodes.natGatewayName" $ }}
        role: node
        cidrBlocks:
        - {{ .Values.connectivity.network.workers.cidr }}
        {{- include "network.subnet.privateEndpoints" (dict "location" .Values.providerSpecific.location "endpoints" .Values.connectivity.network.workers.privateEndpoints) | nindent 8 }}
    vnet:
      {{- if (include "network.vnet.resourceGroup" $) }}
      resourceGroup: {{ include "network.vnet.resourceGroup" $ }}
      {{- end }}
      name: {{ include "network.vnet.name" $ }}
      cidrBlocks:
      - {{ .Values.connectivity.network.hostCidr }}
      {{- if (include "providerSpecific.vnetPeerings" $) }}
      peerings: {{- include "providerSpecific.vnetPeerings" $ | indent 6 }}
      {{- end }}
    {{- if (eq .Values.connectivity.network.mode "private") }}
    privateDNSZoneName: "{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}"
    apiServerLB:
      name: {{ include "resource.default.name" $ }}-api-internal-lb
      type: Internal
      frontendIPs:
      - name: {{ include "resource.default.name" $ }}-api-internal-lb-frontend-ip
        privateIP: "{{- include "controlPlane.apiServerLbIp" .Values.connectivity.network.controlPlane.cidr | trim -}}"
      privateLinks:
      - name: {{ include "resource.default.name" $ }}-api-privatelink
        natIpConfigurations:
        - allocationMethod: Dynamic
          subnet: {{ include "network.subnets.nodes.name" $ }}
        lbFrontendIPConfigNames:
        - {{ include "resource.default.name" $ }}-api-internal-lb-frontend-ip
        allowedSubscriptions:
        - {{ .Values.providerSpecific.subscriptionId }}
        autoApprovedSubscriptions:
        - {{ .Values.providerSpecific.subscriptionId }}
    controlPlaneOutboundLB:
      frontendIPsCount: 1
    {{end}}
  resourceGroup: {{ include "resource.default.name" $ }}
  subscriptionID: {{ .Values.providerSpecific.subscriptionId }}
{{ end }}
