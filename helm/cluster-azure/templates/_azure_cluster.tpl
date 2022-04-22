{{- define "azure-cluster" }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureCluster
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}
  namespace: {{ .Release.Namespace }}
spec:
  azureEnvironment: AzurePublicCloud
  bastionSpec: {}
  controlPlaneEndpoint:
    host: ""
    port: 0
  location: {{ .Values.azure.location }}
  networkSpec:
    apiServerLB:
      frontendIPs:
      - name: {{ include "resource.default.name" $ }}-public-lb-frontEnd
        publicIP:
          name: pip-{{ include "resource.default.name" $ }}-apiserver
      idleTimeoutInMinutes: 4
      name: {{ include "resource.default.name" $ }}-public-lb
      sku: Standard
      type: Public
    nodeOutboundLB:
      frontendIPs:
      - name: {{ include "resource.default.name" $ }}-frontEnd
        publicIP:
          name: pip-{{ include "resource.default.name" $ }}-node-outbound
      frontendIPsCount: 1
      idleTimeoutInMinutes: 4
      name: {{ include "resource.default.name" $ }}
      sku: Standard
      type: Public
    subnets:
    - cidrBlocks:
      - {{ .Values.network.controlPlaneSubnet }}
      name: {{ include "resource.default.name" $ }}-controlplane-subnet
      natGateway:
        ip:
          name: ""
        name: ""
      role: control-plane
      routeTable:
        name: {{ include "resource.default.name" $ }}-node-routetable
      securityGroup:
        name: {{ include "resource.default.name" $ }}-controlplane-nsg
        securityRules:
        - description: Allow K8s API Server
          destination: '*'
          destinationPorts: "6443"
          direction: Inbound
          name: allow_apiserver
          priority: 2201
          protocol: Tcp
          source: '*'
          sourcePorts: '*'
    - cidrBlocks:
      - {{ .Values.network.bastionSubnet }}
      name: {{ include "resource.default.name" $ }}-bastion
      natGateway:
        ip:
          name: ""
        name: ""
      role: node
      routeTable:
        name: {{ include "resource.default.name" $ }}-node-routetable
      securityGroup:
        name: {{ include "resource.default.name" $ }}-bastion
        securityRules:
        - description: Allow SSH access from the internet
          destination: '*'
          destinationPorts: "22"
          direction: Inbound
          name: allow-ssh
          priority: 100
          protocol: Tcp
          source: '*'
          sourcePorts: '*'
    vnet:
      cidrBlocks:
      - {{ .Values.network.vnetCIDR }}
      name: {{ include "resource.default.name" $ }}-vnet
      resourceGroup: {{ include "resource.default.name" $ }}
  resourceGroup: {{ include "resource.default.name" $ }}
  subscriptionID: {{ .Values.azure.subsciptionID }}
{{ end }}
