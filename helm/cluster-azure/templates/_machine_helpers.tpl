{{/*
Helpers to reuse when defining specs for MachinePools and MachineDeployments
*/}}

{{- define "machine-spec" -}}
image:
  computeGallery:
    gallery: {{  $.Values.internal.image.gallery }}
    name: {{ include "flatcarImageName" $ }}
    version: {{ $.Values.internal.image.version }}
osDisk:
  diskSizeGB: {{ .spec.rootVolumeSizeGB | default 300 }}
  managedDisk:
    storageAccountType: Premium_LRS
  osType: Linux
sshPublicKey: {{ include "fake-rsa-ssh-key" $ | b64enc }}
vmSize: {{ .spec.instanceType }}
{{- if ( include "network.subnets.nodes.name" $ ) }}
subnetName: {{ include "network.subnets.nodes.name" $ }}
{{- end }}
{{- end -}}

{{- define "machine-kubeadmconfig-spec" -}}
format: ignition
ignition:
  containerLinuxConfig:
    additionalConfig: |
      systemd:
        units:
        - name: kubeadm.service
          dropins:
          - name: 10-flatcar.conf
            contents: |
              [Unit]
              After=oem-cloudinit.service
        {{- if .Values.internal.teleport.enabled }}
        {{- include "teleportSystemdUnits" $ | nindent 8 }}
        {{- end }}
joinConfiguration:
  nodeRegistration:
    kubeletExtraArgs:
      azure-container-registry-config: /etc/kubernetes/azure.json
      cloud-config: /etc/kubernetes/azure.json
      cloud-provider: external
      eviction-soft: {{ .Values.internal.defaults.softEvictionThresholds }}
      eviction-soft-grace-period: {{ .Values.internal.defaults.softEvictionGracePeriod }}
      eviction-hard: {{ .Values.internal.defaults.hardEvictionThresholds }}
      eviction-minimum-reclaim: {{ .Values.internal.defaults.evictionMinimumReclaim }}
      protect-kernel-defaults: "true"
      node-labels: role=worker,giantswarm.io/machine-{{ternary "pool" "deployment" (eq .spec.type "machinePool")}}={{ include "resource.default.name" $ }}-{{ .spec.name }}{{- if (and (hasKey .spec "customNodeLabels") (gt (len .spec.customNodeLabels) 0) ) }},{{- join "," .spec.customNodeLabels }}{{- end }}
    name: '@@HOSTNAME@@'
    {{- if .spec.customNodeTaints }}
    taints:
    {{- include "customNodeTaints" .spec.customNodeTaints | indent 6 }}
    {{- end }}
files:
  - contentFrom:
      secret:
        key: worker-node-azure.json
        name: {{ include "resource.default.name" $ }}-{{ .spec.name }}{{ ternary (printf "-%s" .hash) "" (hasKey . "hash") }}-azure-json
    owner: root:root
    path: /etc/kubernetes/azure.json
    permissions: "0644"
{{- include "kubeletReservationFiles" $ | nindent 2 }}
{{- include "sshFiles" $ | nindent 2 }}
{{- if $.Values.internal.teleport.enabled }}
{{- include "teleportFiles" . | nindent 2 }}
{{- end }}
{{- include "commonSysctlConfigurations" $ | nindent 2 }}
{{- include "auditRules99Default" $ | nindent 2 }}
{{- include "containerdConfig" $ | nindent 2 }}
preKubeadmCommands:
{{- include "prepare-varLibKubelet-Dir" . | nindent 2 }}
{{- include "kubeletReservationPreCommands" . | nindent 2 }}
{{- include "override-hostname-in-kubeadm-configuration" . | nindent 2 }}
{{- include "override-pause-image-with-quay" . | nindent 2 }}
postKubeadmCommands: []
users:
{{- include "sshUsers" . | nindent 2 }}
{{- end }}

{{/*
# Azure MAchine spec requires us to pass a key anyway and this key MUST be an RSA one - https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/ed25519-ssh-keys
# This is not the key we actually use for ssh
*/}}
{{- define "fake-rsa-ssh-key" -}}
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl9dTHYnfaRf75FTwv2lj5RAvBf4R9o39J5z+Pyf101cNDRSDmbJM1tsadowrvPg8IMqPN2WO77Lbiam3L+WQDxhCCR87mW9qDJa4aVHJZul4GLA+Ij85rOq1Uy2oIAXtuaipVU5H2IdUiDrPZ+Dy9YxsZfWp+3+8WI/OVyxhIwQpb4PN3sbwiSJDF2M91exwnAiHysE3BS0Dk75OMGuzZOmWQ0dnDW0Kazor06stYaIAbeSlf4MQlUE9KcoPMjeBl5GWJVy5nbrm5yl4P+VI6npp8rcFB9YXH9q3nmtkxJF1EdYyHY1VioFlbjwnztvIKgybPC+mlD9LrLFueidS7
{{- end }}
