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
The default name for our images in the Community Gallery is  "capi-flatcar-stable-<KUBERNETES_VERSION>-gen2",
use it when no value is passed in
*/}}
{{- define "flatcarImageName" -}}
{{- if empty .Values.internal.image.name -}}
{{ printf "capi-flatcar-stable-%s-gen2" .Values.internal.kubernetesVersion }}
{{- else -}}
{{ .Values.internal.image.name }}
{{- end -}}
{{- end -}}

{{/*
List of admission plugins to enable based on apiVersion
*/}}
{{- define "enabled-admission-plugins" -}}
{{- $enabledPlugins := list "" -}}
{{- if semverCompare "<1.25.0" .Capabilities.KubeVersion.Version -}}
{{- $enabledPlugins = append $enabledPlugins "PodSecurityPolicy" -}}
{{- end -}}
{{- if not (empty (compact $enabledPlugins)) -}}
,{{- join "," (compact $enabledPlugins) }}
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

{{- define "sshFiles" -}}
- path: /etc/ssh/trusted-user-ca-keys.pem
  permissions: "0600"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/ssh/trusted-user-ca-keys.pem") . | b64enc }}
- path: /etc/ssh/sshd_config
  permissions: "0600"
  encoding: base64
  content: {{ $.Files.Get "files/etc/ssh/sshd_config" | b64enc }}
{{- end -}}

{{- define "sshFilesBastion" -}}
- path: /etc/ssh/trusted-user-ca-keys.pem
  permissions: "0600"
  encoding: base64
  content: {{ tpl ($.Files.Get "files/etc/ssh/trusted-user-ca-keys.pem") . | b64enc }}
- path: /etc/ssh/sshd_config
  permissions: "0600"
  encoding: base64
  content: {{ $.Files.Get "files/etc/ssh/sshd_config_bastion" | b64enc }}
{{- end -}}

{{- define "sshUsers" -}}
- name: giantswarm
  groups: sudo
  sudo: ALL=(ALL) NOPASSWD:ALL
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

{{- define "prepare-varLibKubelet-Dir" -}}
- /bin/test ! -d /var/lib/kubelet && (/bin/mkdir -p /var/lib/kubelet && /bin/chmod 0750 /var/lib/kubelet)
{{- end -}}

# the replacement must match the value from `joinConfiguration.nodeConfiguration.name`
{{- define "override-hostname-in-kubeadm-configuration" -}}
- sed -i "s/'@@HOSTNAME@@'/$(curl -s -H Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance?api-version=2020-09-01' | jq -r .compute.name)/g" /etc/kubeadm.yml
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
  scope: /subscriptions/{{ $.Values.providerSpecific.subscriptionId }}/resourceGroups/{{ include "resource.default.name" $ }}
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
