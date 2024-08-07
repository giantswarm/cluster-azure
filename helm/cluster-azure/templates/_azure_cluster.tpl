{{- define "azure-cluster" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureCluster
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
    {{- include "preventDeletionLabel" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  {{- include "additional-tags" . | indent 2}}
  identityRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureClusterIdentity
    name: {{ .Values.global.providerSpecific.azureClusterIdentity.name }}
    namespace: {{ .Values.global.providerSpecific.azureClusterIdentity.namespace }}
  location: {{ .Values.global.providerSpecific.location }}
  networkSpec:
    subnets:
      - name: {{ include "network.subnets.controlPlane.name" $ }}
        role: control-plane
        routeTable:
          name: {{ include "network.subnets.controlPlane.routeTableName" $ }}
        cidrBlocks:
        - {{ .Values.global.connectivity.network.controlPlane.cidr }}
        {{- include "network.subnet.privateEndpoints" (dict "location" .Values.global.providerSpecific.location "endpoints" .Values.global.connectivity.network.controlPlane.privateEndpoints) | nindent 8 -}}
        securityGroup:
          name: {{ include "resource.default.name" $ }}-controlplane-nsg
          securityRules:
        {{- if (gt (len .Values.global.connectivity.allowedCIDRs) 0) }}
        {{- include "controlPlaneSecurityGroups" .Values.global.connectivity.allowedCIDRs | nindent 12 }}
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
        routeTable:
          name: {{ include "network.subnets.nodes.routeTableName" $ }}
        cidrBlocks:
        - {{ .Values.global.connectivity.network.workers.cidr }}
        {{- include "network.subnet.privateEndpoints" (dict "location" .Values.global.providerSpecific.location "endpoints" .Values.global.connectivity.network.workers.privateEndpoints) | nindent 8 }}
    vnet:
      {{- if (include "network.vnet.resourceGroup" $) }}
      resourceGroup: {{ include "network.vnet.resourceGroup" $ }}
      {{- end }}
      name: {{ include "network.vnet.name" $ }}
      cidrBlocks:
      - {{ .Values.global.connectivity.network.hostCidr }}
      {{- if (include "providerSpecific.vnetPeerings" $) }}
      peerings: {{- include "providerSpecific.vnetPeerings" $ | indent 6 }}
      {{- end }}
    {{- if (eq .Values.global.connectivity.network.mode "private") }}
    privateDNSZoneName: "{{ include "resource.default.name" $ }}.{{ .Values.global.connectivity.baseDomain }}"
    apiServerLB:
      name: {{ include "resource.default.name" $ }}-api-internal-lb
      type: Internal
      frontendIPs:
      - name: {{ include "resource.default.name" $ }}-api-internal-lb-frontend-ip
        privateIP: "{{- include "controlPlane.apiServerLbIp" .Values.global.connectivity.network.controlPlane.cidr | trim -}}"
      privateLinks:
      - name: {{ include "resource.default.name" $ }}-api-privatelink
        natIpConfigurations:
        - allocationMethod: Dynamic
          subnet: {{ include "network.subnets.nodes.name" $ }}
        lbFrontendIPConfigNames:
        - {{ include "resource.default.name" $ }}-api-internal-lb-frontend-ip
        allowedSubscriptions:
        - {{ .Values.global.providerSpecific.subscriptionId }}
        {{- range .Values.global.providerSpecific.allowedSubscriptions }}
        - {{ . }}
        {{- end }}
        autoApprovedSubscriptions:
        - {{ .Values.global.providerSpecific.subscriptionId }}
        {{- range .Values.global.providerSpecific.allowedSubscriptions }}
        - {{ . }}
        {{- end }}
    controlPlaneOutboundLB:
      frontendIPsCount: 1
    {{end}}
  resourceGroup: {{ include "resource.default.name" $ }}
  subscriptionID: {{ .Values.global.providerSpecific.subscriptionId }}
{{ end }}
