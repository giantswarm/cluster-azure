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
cluster.x-k8s.io/watch-filter: capi
giantswarm.io/cluster: {{ include "resource.default.name" . | quote }}
giantswarm.io/organization: {{ .Values.organization | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
release.giantswarm.io/version: {{ .Values.releaseVersion | quote }}
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

{{- define "kubernetesFiles" -}}
- path: /etc/kubernetes/policies/audit-policy.yaml
  permissions: "0600"
  encoding: base64
  content: {{ $.Files.Get "files/etc/kubernetes/policies/audit-policy.yaml" | b64enc }}
- path: /etc/kubernetes/encryption/config.yaml
  permissions: "0600"
  contentFrom:
    secret:
      name: {{ include "resource.default.name" $ }}-encryption-provider-config
      key: encryption
{{- end -}}

{{- define "sshUsers" -}}
- name: giantswarm
  groups: sudo
  sudo: ALL=(ALL) NOPASSWD:ALL
{{- end -}}

{{- define "ignitionBaseConfigLinks" -}}
# For some reason enabling services via systemd.units doesn't work on Flatcar CAPI AMIs.
- path: /etc/systemd/system/multi-user.target.wants/coreos-metadata.service
  target: /usr/lib/systemd/system/coreos-metadata.service
- path: /etc/systemd/system/multi-user.target.wants/kubeadm.service
  target: /etc/systemd/system/kubeadm.service
{{- end -}}

{{- define "ignitionBaseConfigUnits" -}}
- name: kubeadm.service
  dropins:
  - name: 10-flatcar.conf
    contents: |
      [Unit]
      # kubeadm must run after coreos-metadata populated /run/metadata directory.
      Requires=coreos-metadata.service
      After=coreos-metadata.service
      [Service]
      # Ensure kubeadm service has access to kubeadm binary in /opt/bin on Flatcar.
      Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/bin
      # To make metadata environment variables available for pre-kubeadm commands.
      EnvironmentFile=/run/metadata/*
{{- end -}}

{{- define "ignitionDecodeBase64SSH" -}}
- 'files="/etc/ssh/trusted-user-ca-keys.pem /etc/ssh/sshd_config"; for f in $files; do tmpFile=$(mktemp); cat "${f}" | base64 -d > ${tmpFile}; if [ "$?" -eq 0 ]; then mv ${tmpFile} ${f};fi;  done;'
- systemctl restart sshd
{{- end -}}

{{- define "ignitionDecodeBase64ControlPlane" -}}
- 'files="/etc/ssh/trusted-user-ca-keys.pem /etc/ssh/sshd_config /etc/kubernetes/policies/audit-policy.yaml"; for f in $files; do tmpFile=$(mktemp); cat "${f}" | base64 -d > ${tmpFile}; if [ "$?" -eq 0 ]; then mv ${tmpFile} ${f};fi;  done;'
- systemctl restart sshd
{{- end -}}
