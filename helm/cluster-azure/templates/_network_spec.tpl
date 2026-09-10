{{/**
The network configuration varies a lot depending on the configured network mode.
It is extracted here and fully deduplicated between each mode to make it easier
to reason about what each mode does and requires.
*/}}
{{- define "network.spec" -}}
{{- with $.Values.global.connectivity.network -}}
{{- if eq .mode "public" -}}
{{ include "network.spec.public" $ }}
{{- else if eq .mode "private" -}}
{{ include "network.spec.private" $ }}
{{- else if eq .mode "byon" -}}
{{ include "network.spec.byon" $ }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/**
Public clusters are deployed with publicly accessible API servers in standalone VNETs managed by CAPZ.
*/}}
{{- define "network.spec.public" -}}
vnet:
  name: {{ include "network.vnet.name" $ }}
  cidrBlocks:
  - {{ .Values.global.connectivity.network.hostCidr }}
  {{- if (include "providerSpecific.vnetPeerings" $) }}
  peerings: {{- include "providerSpecific.vnetPeerings" $ | indent 6 }}
  {{- end }}
subnets:
  - name: {{ include "network.subnets.controlPlane.name" $ }}
    role: control-plane
    routeTable:
      name: {{ include "network.subnets.controlPlane.routeTableName" $ }}
    cidrBlocks:
    - {{ .Values.global.connectivity.network.controlPlane.cidr }}
    {{- include "network.subnet.privateEndpoints" (dict "location" .Values.global.providerSpecific.location "endpoints" .Values.global.connectivity.network.controlPlane.privateEndpoints) | nindent 8 }}
    securityGroup:
      name: {{ include "network.subnets.controlPlane.securityGroupName" $ }}
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
    securityGroup:
      name: {{ include "network.subnets.nodes.securityGroupName" $ }}
{{- end -}}

{{/**
Private clusters are deployed with privately accessible API servers in standalone VNETs managed by CAPZ.
Communication between the MC and WC is enabled through private links. Additional private links
are dynamically added to the MC AzureCluster for every private WC by our own operator.
*/}}
{{- define "network.spec.private" -}}
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
subnets:
  - name: {{ include "network.subnets.controlPlane.name" $ }}
    role: control-plane
    routeTable:
      name: {{ include "network.subnets.controlPlane.routeTableName" $ }}
    cidrBlocks:
    - {{ .Values.global.connectivity.network.controlPlane.cidr }}
    {{- include "network.subnet.privateEndpoints" (dict "location" .Values.global.providerSpecific.location "endpoints" .Values.global.connectivity.network.controlPlane.privateEndpoints) | nindent 8 }}
    securityGroup:
      name: {{ include "network.subnets.controlPlane.securityGroupName" $ }}
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
    securityGroup:
      name: {{ include "network.subnets.nodes.securityGroupName" $ }}
privateDNSZoneName: "{{ include "resource.default.name" $ }}.{{ .Values.global.connectivity.baseDomain }}"
apiServerLB:
  name: {{ include "resource.default.name" $ }}-api-internal-lb
  type: Internal
  frontendIPs:
  - name: {{ include "resource.default.name" $ }}-api-internal-lb-frontend-ip
    privateIP: "{{- include "controlPlane.apiServerLbIp" .Values.global.connectivity.network.controlPlane.cidr | trim -}}"
  {{- if .Values.global.connectivity.network.enablePrivateLinkWithPrivateMode }}
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
  {{- end }}
controlPlaneOutboundLB:
  frontendIPsCount: 1
{{- end -}}

{{/**
BYON clusters are deployed with privately accessible API servers in a VNET managed by the customer.
We assume that both the MC and WC are private, and that the customer manages any required connectivity
between MC and WC VNETs, and to the internet. Usually this is used for customers that have a Virtual WAN setup.
*/}}
{{- define "network.spec.byon" -}}
vnet:
  name: {{ include "network.vnet.name" $ }}
  resourceGroup: {{ include "network.vnet.resourceGroup" $ }}
  cidrBlocks:
  - {{ .Values.global.connectivity.network.hostCidr }}
subnets:
  - name: {{ include "network.subnets.controlPlane.name" $ }}
    role: control-plane
    cidrBlocks:
    - {{ .Values.global.connectivity.network.controlPlane.cidr }}
    routeTable:
      name: {{ include "network.subnets.controlPlane.routeTableName" $ }}
    securityGroup:
      name: {{ include "network.subnets.controlPlane.securityGroupName" $ }}
  - name: {{ include "network.subnets.nodes.name" $ }}
    role: node
    cidrBlocks:
    - {{ .Values.global.connectivity.network.workers.cidr }}
    routeTable:
      name: {{ include "network.subnets.nodes.routeTableName" $ }}
    securityGroup:
      name: {{ include "network.subnets.nodes.securityGroupName" $ }}
    natGateway:
      # Setting the name to an empty string disables creation.
      name: ""
      ip:
        name: ""
privateDNSZoneName: "{{ include "resource.default.name" $ }}.{{ .Values.global.connectivity.baseDomain }}"
apiServerLB:
  name: {{ include "resource.default.name" $ }}-api-internal-lb
  type: Internal
  frontendIPsCount: 1
{{- end -}}
