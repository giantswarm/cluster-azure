{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
{{- include "labels.selector" $ }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels.selector" -}}
app: {{ include "name" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . | quote }}
giantswarm.io/cluster: {{ include "resource.default.name" . | quote }}
giantswarm.io/organization: {{ required "You must provide an existing organization" .Values.metadata.organization | quote }}
{{- end -}}

{{/*
Create a name stem for resource names
When resources are created from templates by Cluster API controllers, they are given random suffixes.
Given that Kubernetes allows 63 characters for resource names, the stem is truncated to 47 characters to leave
room for such suffix.
*/}}
{{- define "resource.default.name" -}}
{{- .Values.metadata.name | default (.Release.Name | replace "." "-" | trunc 47 | trimSuffix "-") -}}
{{- end -}}

{{/*
The default name for our images in the Community Gallery is  "capi-flatcar-stable-<KUBERNETES_VERSION>-gen2-gs",
use it when no value is passed in
*/}}
{{- define "flatcarImageName" -}}
{{- if empty .Values.internal.image.name -}}
{{ printf "capi-flatcar-stable-%s-gen2-gs" .Values.internal.kubernetesVersion }}
{{- else -}}
{{ .Values.internal.image.name }}
{{- end -}}
{{- end -}}

{{/*
List of admission plugins to enable based on apiVersion

When comparing the KubernetesVersion we must use the Target version of the cluster we are about to insteall
*/}}
{{- define "enabled-admission-plugins" -}}
{{- $enabledPlugins := list "" -}}
{{- $enabledPlugins = append $enabledPlugins "NamespaceLifecycle" -}}
{{- $enabledPlugins = append $enabledPlugins "LimitRanger" -}}
{{- $enabledPlugins = append $enabledPlugins "ServiceAccount" -}}
{{- $enabledPlugins = append $enabledPlugins "ResourceQuota" -}}
{{- $enabledPlugins = append $enabledPlugins "DefaultStorageClass" -}}
{{- $enabledPlugins = append $enabledPlugins "PersistentVolumeClaimResize" -}}
{{- $enabledPlugins = append $enabledPlugins "Priority" -}}
{{- $enabledPlugins = append $enabledPlugins "DefaultTolerationSeconds" -}}
{{- $enabledPlugins = append $enabledPlugins "MutatingAdmissionWebhook" -}}
{{- $enabledPlugins = append $enabledPlugins "ValidatingAdmissionWebhook" -}}
{{- if semverCompare "<1.25-0" .Values.internal.kubernetesVersion -}}
{{- $enabledPlugins = append $enabledPlugins "PodSecurityPolicy" -}}
{{- end -}}
{{- if not (empty (compact $enabledPlugins)) -}}
{{- join "," (compact $enabledPlugins) }}
{{- end -}}
{{- end -}}

{{/*
List of feature gates to enable based on apiVersion

When comparing the KubernetesVersion we must use the Target version of the cluster we are about to insteall
*/}}
{{- define "enabled-feature-gates" -}}
{{- $enabledFeatureGates := list "" -}}
{{- if semverCompare "<1.25-0" .Values.internal.kubernetesVersion -}}
{{- $enabledFeatureGates = append $enabledFeatureGates "TTLAfterFinished=true" -}}
{{- end -}}
{{- if not (empty (compact $enabledFeatureGates)) -}}
{{- join "," (compact $enabledFeatureGates) }}
{{- end -}}
{{- end -}}

{{/*Helper to define per cluster User Assigned Identity prefix*/}}
{{- define "vmUaIdentityPrefix" -}}
/subscriptions/{{ .Values.providerSpecific.subscriptionId }}/resourceGroups/{{ include "resource.default.name" . }}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{{ include "resource.default.name" . }}
{{- end -}}

{{/*Render list of custom Taints from passed values*/}}
{{- define "customNodeTaints" -}}
{{- if (gt (len .) 0) }}
{{- range . }}
{{- if or (not .key) (not .value) (not .effect) }}
{{ fail (printf ".customNodeTaints element must have [key, value, effect]")}}
{{- end }}
- key: {{ .key | quote }}
  value: {{ .value | quote }}
  effect: {{ .effect | quote }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "oidcFiles" -}}
{{- if ne .Values.controlPlane.oidc.caPem "" }}
- path: /etc/ssl/certs/oidc.pem
  permissions: "0600"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/ssl/certs/oidc.pem") . | b64enc }}
{{- end }}
{{- end -}}


{{- define "kubeletReservationFiles" -}}
- path: /opt/bin/calculate_kubelet_reservations.sh
  permissions: "0754"
  encoding: base64
  content: {{ $.Files.Get "files/opt/bin/calculate_kubelet_reservations.sh" | b64enc }}
{{- end -}}


{{/*
The secret `-teleport-join-token` is created by the teleport-operator in cluster namespace
and is used to join the node to the teleport cluster.
*/}}
{{- define "teleportFiles" -}}
- path: /etc/teleport-join-token
  permissions: "0644"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-teleport-join-token
      key: joinToken
- path: /opt/teleport-node-role.sh
  permissions: "0755"
  encoding: base64
  content: {{ $.Files.Get "files/opt/teleport-node-role.sh" | b64enc }}
- path: /etc/teleport.yaml
  permissions: "0644"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/teleport.yaml") . | b64enc }}
{{- end -}}


{{- define "teleportSystemdUnits" -}}
- name: teleport.service
  enabled: true
  contents: |
    [Unit]
    Description=Teleport Service
    After=network.target

    [Service]
    Type=simple
    Restart=on-failure
    ExecStart=/opt/bin/teleport start --roles=node --config=/etc/teleport.yaml --pid-file=/run/teleport.pid
    ExecReload=/bin/kill -HUP $MAINPID
    PIDFile=/run/teleport.pid
    LimitNOFILE=524288

    [Install]
    WantedBy=multi-user.target
{{- end -}}


# Custom Sysctl settings
# https://github.com/giantswarm/roadmap/issues/1659#issuecomment-1452359468
{{- define "commonSysctlConfigurations" -}}
- path: /etc/sysctl.d/10_giantswarm_tuning.conf
  permissions: "0444"
  encoding: base64
  content: {{ $.Files.Get "files/etc/sysctl.d/tuning.conf" | b64enc }}
{{- end -}}

{{- define "auditRules99Default" -}}
- path: /etc/audit/rules.d/99-default.rules
  permissions: "0444"
  encoding: base64
  content: {{ $.Files.Get "files/etc/audit/rules.d/99-default.rules" | b64enc }}
{{- end -}}

{{- define "kubeletReservationPreCommands" -}}
- /opt/bin/calculate_kubelet_reservations.sh
{{- end -}}

{{/*
Modify /etc/hosts in order to route API server requests to the local API server replica.
See more details here https://github.com/giantswarm/roadmap/issues/2223.
*/}}
{{- define "kubeadm.controlPlane.privateNetwork.preCommands" -}}
- if [ ! -z "$(grep "^kubeadm init*" "/etc/kubeadm.sh")" ]; then echo '127.0.0.1   apiserver.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}
  apiserver' >> /etc/hosts; fi
{{- end -}}

{{/*
Modify /etc/hosts in order to route API server requests to the local API server replica.
See more details here https://github.com/giantswarm/roadmap/issues/2223.
*/}}
{{- define "kubeadm.controlPlane.privateNetwork.postCommands" -}}
- if [ ! -z "$(grep "^kubeadm join*" "/etc/kubeadm.sh")" ]; then
  echo '127.0.0.1   apiserver.{{ include "resource.default.name" $ }}.{{ .Values.baseDomain }}' >> /etc/hosts;
  fi
{{- end -}}

{{- define "prepare-varLibKubelet-Dir" -}}
- /bin/test ! -d /var/lib/kubelet && (/bin/mkdir -p /var/lib/kubelet && /bin/chmod 0750 /var/lib/kubelet)
{{- end -}}

# the replacement must match the value from `joinConfiguration.nodeConfiguration.name`
{{- define "override-hostname-in-kubeadm-configuration" -}}
- sed -i "s/'@@HOSTNAME@@'/$(curl -s -H Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance?api-version=2020-09-01' | jq -r .compute.name)/g" /etc/kubeadm.yml
{{- end -}}

# Replace the pause image with our quay.io one
# Won't be needed anymore once https://github.com/giantswarm/capi-image-builder/pull/81 has been released and new images build out of it
{{- define "override-pause-image-with-quay" -}}
- sed -i -e 's/registry.k8s.io\/pause/quay.io\/giantswarm\/pause/' /etc/sysconfig/kubelet
{{- end -}}

{{/*
Hash function based on data provided
Expects two arguments (as a `dict`) E.g.
  {{ include "hash" (dict "data" . "global" $global) }}
Where `data` is the data to has on and `global` is the top level scope.
*/}}
{{- define "hash" -}}
{{- $data := mustToJson .data | toString  }}
{{- (printf "%s%s" $data) | quote | sha1sum | trunc 8 }}
{{- end -}}

{{/*
Helpers to define Identity Configuration

Type can be either "SystemAssigned" or "UserAssigned"

with UserAssigned we support both a list of Identities passed through the Values to be attached on top of the default set of
* -cp ( controlplane nodes )
* -nodes ( worker nodes )
* -capz ( On management Clusters used by the capz controller NMI )

with SystemAssigned we set the `Contributor` Role on the resourceGroup
the list of roles is https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

this function requires an object like this to be passed in

{{ $identity := dict "type" "controlPlane" "Values" $.Values "Release" $.Release }}

*/}}
{{- define "renderIdentityConfiguration" -}}
{{- $identity := .Values.internal.identity -}}
identity: {{ $identity.type }}
{{- if eq $identity.type "SystemAssigned" }}
systemAssignedIdentityRole:
  scope: /subscriptions/{{ $.Values.providerSpecific.subscriptionId }}{{ ternary ( printf "/resourceGroups/%s" ( include "resource.default.name" $ ) ) "" (eq $identity.systemAssignedScope "ResourceGroup") }}
  definitionID: /subscriptions/{{ $.Values.providerSpecific.subscriptionId }}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c
{{- else }}
userAssignedIdentities:
  {{- $defaultIdentities := list (ternary "cp" "nodes" (eq .type "controlPlane")) (ternary "capz" "" ($identity.attachCapzControllerUserAssignedIdentity)) }}
  {{- range compact $defaultIdentities }}
  - providerID: /subscriptions/{{ $.Values.providerSpecific.subscriptionId }}/resourceGroups/{{ include "resource.default.name" $ }}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{{ include "resource.default.name" $ }}-{{ . }}
  {{- end -}}
  {{- if and ($identity.userAssignedIdentities) (not (empty $identity.userAssignedIdentities)) }}
    {{- range $identity.userAssignedIdentities}}
  - providerID: {{ . }}
    {{- end -}}
  {{- end -}}
{{- end }}
{{- end -}}

{{- define "containerdConfig" -}}
- path: /etc/containerd/config.toml
  permissions: "0644"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-containerd-configuration
      key: registry-config.toml
{{- end -}}

{{/*
Calculating API server load balancer IP based on control plane subnet CIDR.

It expects one argument which is the control plane subnet network range in format "a.b.c.d/xx"
*/}}
{{- define "controlPlane.apiServerLbIp" -}}
{{ $cidrParts := split "/" . }}
{{ $ipParts := split "." $cidrParts._0 }}
{{ $lastPart := $ipParts._3 | int | add 10 }}
{{- $ipParts._0 -}}.{{- $ipParts._1 -}}.{{- $ipParts._2 -}}.{{- $lastPart -}}
{{- end -}}

{{- define "network.subnets.controlPlane.name" -}}
{{- if hasKey $.Values.internal.network.subnets "controlPlaneSubnetName" -}}
{{ $.Values.internal.network.subnets.controlPlaneSubnetName }}
{{- else -}}
control-plane-subnet
{{- end -}}
{{- end -}}

{{- define "network.subnets.nodes.name" -}}
{{- if hasKey $.Values.internal.network.subnets "nodesSubnetName" -}}
{{ $.Values.internal.network.subnets.nodesSubnetName }}
{{- else -}}
node-subnet
{{- end -}}
{{- end -}}

{{- define "network.subnets.nodes.natGatewayName" -}}
{{- if hasKey $.Values.internal.network.subnets "nodeSubnetNatGatewayName" -}}
{{ $.Values.internal.network.subnets.nodeSubnetNatGatewayName }}
{{- else -}}
node-natgateway
{{- end -}}
{{- end -}}

{{- define "network.subnet.privateEndpoints" -}}
{{- if (gt (len $) 0) -}}
privateEndpoints:
{{ range $idx, $epDefinition := $.endpoints -}}
{{- $name := $epDefinition.name -}}
{{- $location := $.location -}}
{{- $links := $epDefinition.privateLinkServiceConnections -}}
- name: {{ $name }}
  location: {{ $location }}
  privateLinkServiceConnections:
  {{- range $link := $links }}
  - privateLinkServiceID: {{ $link }}
  {{- end }}
{{ end -}}
{{- end -}}
{{- end -}}

{{- define "network.vnet.resourceGroup" -}}
{{- if and ($.Values.internal.network.vnet.resourceGroup) ($.Values.internal.network.vnet.name) -}}
{{ $.Values.internal.network.vnet.resourceGroup }}
{{- end -}}
{{- end -}}

{{- define "network.vnet.name" -}}
{{- if $.Values.internal.network.vnet.name -}}
{{ $.Values.internal.network.vnet.name }}
{{- else -}}
{{- if ($.Values.internal.network.vnet.resourceGroup) -}}
{{- fail "When explicitly specifying VNet resource group, you also must explicitly specify the VNet name" }}
{{- end -}}
{{ include "resource.default.name" $ }}-vnet
{{- end -}}
{{- end -}}

{{- define "providerSpecific.peeringFromWCToMC" -}}
- resourceGroup: {{ $.Values.managementCluster }}
  remoteVnetName: {{ $.Values.managementCluster }}-vnet
  forwardPeeringProperties:
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
  reversePeeringProperties:
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
{{- end -}}

{{/*
  All peerings, both explicit and implicit.
  1. Explicit peerings that are defined in config under .providerSpecific.network.peerings.
  2. Implicit WC VNet toMC Vnet peering.
*/}}
{{- define "providerSpecific.vnetPeerings" }}

{{- /*
  Include explicitly configured VNet peerings
*/}}
{{- if .Values.providerSpecific.network.peerings }}
{{ .Values.providerSpecific.network.peerings | toYaml }}
{{- end }}

{{- /*
  Include peering from workload cluster to management cluster. This is added only to clusters that meet all of the
  following conditions:
  - The cluster is not the managment cluster itself (as it cannot have peering to its own network). For this we check
    that cluster name is different than MC name.
  - The cluster is a private workload cluster.
  - The VPN gateway mode is set to "remote" (which means that the cluster uses a remote VPN gateway thought the VNet
    peering)
*/ -}}
{{- if and (ne $.Values.metadata.name $.Values.managementCluster) (eq .Values.connectivity.network.mode "private") (eq .Values.internal.network.vpn.gatewayMode "remote") }}
{{ include "providerSpecific.peeringFromWCToMC" $ }}
{{- end }}

{{- end -}}

{{/*
k explain azurecluster.spec.networkSpec.subnets.securityGroup.securityRules.priority
KIND:     AzureCluster
VERSION:  infrastructure.cluster.x-k8s.io/v1beta1

FIELD:    priority <integer>

DESCRIPTION:
     Priority is a number between 100 and 4096. Each rule should have a unique
     value for priority. Rules are processed in priority order, with lower
     numbers processed before higher numbers. Once traffic matches a rule,
     processing stops.

From: https://learn.microsoft.com/en-us/azure/virtual-network/service-tags-overview

VirtualNetwork

The virtual network address space (all IP address ranges defined for the virtual network),
all connected on-premises address spaces, peered virtual networks, virtual networks connected
to a virtual network gateway, the virtual IP address of the host, and address prefixes used
on user-defined routes. This tag might also contain default routes.

AzureLoadBalancer

The Azure infrastructure load balancer. The tag translates to the virtual IP address of
the host (168.63.129.16) where the Azure health probes originate. This only includes
probe traffic, not real traffic to your backend resource. If you're not using
Azure Load Balancer, you can override this rule.


For a new WC, the following IPs must be also set:
glippy outbound lb ip 20.4.101.180
glippy nat-ip 20.4.101.216


*/}}

{{- define "controlPlaneSecurityGroups" -}}
- name: "allow_apiserver_from_gridscale"
  description: "Allow K8s API Server"
  direction: "Inbound"
  priority: 152
  protocol: "*"
  destination: "*"
  destinationPorts: "6443"
  source: "185.102.95.187"
  sourcePorts: "*"
- name: "allow_apiserver_from_vultr"
  description: "Allow K8s API Server"
  direction: "Inbound"
  priority: 153
  protocol: "*"
  destination: "*"
  destinationPorts: "6443"
  source: "95.179.153.65"
  sourcePorts: "*"
- name: "allow_apiserver_from_virtual_network"
  description: "Allow K8s API Server"
  direction: "Inbound"
  priority: 154
  protocol: "*"
  destination: "*"
  destinationPorts: "6443"
  source: "VirtualNetwork"
  sourcePorts: "*"
- name: "allow_apiserver_from_azure_lb"
  description: "Allow K8s API Server"
  direction: "Inbound"
  priority: 155
  protocol: "*"
  destination: "*"
  destinationPorts: "6443"
  source: "AzureLoadBalancer"
  sourcePorts: "*"
{{- range $index, $value := . }}
- name: "allow_apiserver_from_{{ $value | replace "/" "_" }}"
  description: "Allow K8s API Server"
  direction: "Inbound"
  priority: {{ add $index 500 }}
  protocol: "*"
  destination: "*"
  destinationPorts: "6443"
  source: {{ $value | quote}}
  sourcePorts: "*"
{{- end }}
{{- end -}}

{{/*
    clusterDNS IP is defined as 10th IP of the service CIDR in kubeadm. See:
    https://github.com/kubernetes/kubernetes/blob/d89d5ab2680bc74fe4487ad71e514f4e0812d9ce/cmd/kubeadm/app/constants/constants.go#L644-L645
    Such advanced logic can't be used in helm chart. Instead there is an
    assertion that the network is bigger than /24 and the last octet simply
    replaced with .10.
*/}}
{{- define "clusterDNS" -}}
    {{- $serviceCidrBlock := .Values.connectivity.network.serviceCidr  -}}
    {{- $mask := int (mustRegexReplaceAll `^.*/(\d+)$` $serviceCidrBlock "${1}") -}}
    {{- if gt $mask 24 -}}
        {{- fail (printf ".Values.connectivity.network.serviceCidr=%q mask must be <= 24" $serviceCidrBlock) -}}
    {{- end -}}
    {{- mustRegexReplaceAll `^(\d+\.\d+\.\d+).*$` $serviceCidrBlock "${1}.10" -}}
{{- end -}}
