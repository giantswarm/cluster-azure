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
app: {{ include "name" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" . | quote }}
giantswarm.io/cluster: {{ include "resource.default.name" . | quote }}
giantswarm.io/organization: {{ .Values.organization | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
cluster.x-k8s.io/watch-filter: capi
{{- end -}}

{{/*
Create a name stem for resource names
When resources are created from templates by Cluster API controllers, they are given random suffixes.
Given that Kubernetes allows 63 characters for resource names, the stem is truncated to 47 characters to leave
room for such suffix.
*/}}
{{- define "resource.default.name" -}}
{{- .Values.clusterName | default (.Release.Name | replace "." "-" | trunc 47 | trimSuffix "-") -}}
{{- end -}}

{{/*
Helpers to define Identity blocks

Type can be either "SystemAssigned" or "UserAssigned"

with UserAssigned we support both a list of Identities passed through the Values or a default set of
* -cp ( controlplane nodes )
* -nodes ( worker nodes )
* -capz ( On management Clusters used by the capz controller NMI )
*/}}
{{- define "renderIdentityConfiguration" -}}
{{- $identity := .this.identity | default .Values.defaults.identity  -}}
identity: {{ $identity.type }}
{{- if eq $identity.type "SystemAssigned" }}
{{- /* depends on https://github.com/kubernetes-sigs/cluster-api-provider-azure/pull/2965
scope: {{ $identity.scope }}
roleDefinitionID: {{ $identity.roleDefinitionID }}
*/}}
{{- else if eq $identity.type "UserAssigned" }}
userAssignedIdentities:
  {{- if and ($identity.userAssignedIdentities) (not (empty $identity.userAssignedIdentities)) }}
    {{- range $identity.userAssignedIdentities}}
  - providerID: {{ . }}
    {{- end -}}
  {{- else }}
    {{- $defaultIdentities := list (ternary "cp" "nodes" (eq .instance "controlPlane")) (ternary "capz" "" (.Values.managementCluster)) }}
    {{- range compact $defaultIdentities }}
  - providerID: /subscriptions/{{ $.Values.azure.subscriptionId }}/resourceGroups/{{ include "resource.default.name" $ }}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{{ include "resource.default.name" $ }}-{{ . }}
    {{- end -}}
  {{- end -}}
{{- else -}}
{{ fail (printf "Only SystemAssigned and UserAssigned identities are supported") }}
{{- end }}
{{- end -}}



{{/*Helpers to define Files Rendering*/}}
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
{{- if ne .Values.oidc.caPem "" }}
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

{{- define "kubeletReservationPreCommands" -}}
- /opt/bin/calculate_kubelet_reservations.sh
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
