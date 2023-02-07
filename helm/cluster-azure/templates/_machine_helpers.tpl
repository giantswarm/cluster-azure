{{/*
Helpers to reuse when defining specs for MachinePools and MachineDeployments
*/}}

{{- define "machine-identity" -}}
{{- if .Values.enablePerClusterIdentity -}}
identity: UserAssigned
userAssignedIdentities:
  - providerID: {{ include "vmUaIdentityPrefix" $ }}-cp
  {{- if .Values.attachCapzControllerIdentity }}
  - providerID: {{ include "vmUaIdentityPrefix" $ }}-capz
  {{- end }}
{{ end -}}
{{- end -}}

{{- define "machine-spec" -}}
osDisk:
  diskSizeGB: {{ .spec.rootVolumeSizeGB }}
  managedDisk:
    storageAccountType: Premium_LRS
  osType: Linux
sshPublicKey: {{ include "fake-rsa-ssh-key" $ | b64enc }}
vmSize: {{ .spec.instanceType }}
{{- end -}}

{{- define "machine-kubeadmconfig-spec" -}}
joinConfiguration:
  nodeRegistration:
    kubeletExtraArgs:
      azure-container-registry-config: /etc/kubernetes/azure.json
      cloud-config: /etc/kubernetes/azure.json
      cloud-provider: external
      feature-gates: CSIMigrationAzureDisk=true
      eviction-soft: {{ .spec.softEvictionThresholds | default .Values.defaults.softEvictionThresholds }}
      eviction-soft-grace-period: {{ .spec.softEvictionGracePeriod | default .Values.defaults.softEvictionGracePeriod }}
      eviction-hard: {{ .spec.hardEvictionThresholds | default .Values.defaults.hardEvictionThresholds }}
      eviction-minimum-reclaim: {{ .Values.controlPlane.evictionMinimumReclaim | default .Values.defaults.evictionMinimumReclaim }}
      node-labels: role=worker,giantswarm.io/machine-{{ternary "pool" "deployment" (eq .type "machinePool")}}={{ include "resource.default.name" $ }}-{{ .spec.name }}{{- if (and (hasKey .spec "customNodeLabels") (gt (len .spec.customNodeLabels) 0) ) }},{{- join "," .spec.customNodeLabels }}{{- end }}
    name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
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
preKubeadmCommands:
{{- include "kubeletReservationPreCommands" . | nindent 2 }}
postKubeadmCommands: []
users:
{{- include "sshUsers" . | nindent 2 }}
{{- end }}

{{/*
# Azure MAchine spec requires us to pass a key anyway and this key MUST be an RSA one - https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/ed25519-ssh-keys
# This is not the key we actually use for ssh
*/}}
{{- define "fake-rsa-ssh-key" -}}
fakeRSAKEY: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl9dTHYnfaRf75FTwv2lj5RAvBf4R9o39J5z+Pyf101cNDRSDmbJM1tsadowrvPg8IMqPN2WO77Lbiam3L+WQDxhCCR87mW9qDJa4aVHJZul4GLA+Ij85rOq1Uy2oIAXtuaipVU5H2IdUiDrPZ+Dy9YxsZfWp+3+8WI/OVyxhIwQpb4PN3sbwiSJDF2M91exwnAiHysE3BS0Dk75OMGuzZOmWQ0dnDW0Kazor06stYaIAbeSlf4MQlUE9KcoPMjeBl5GWJVy5nbrm5yl4P+VI6npp8rcFB9YXH9q3nmtkxJF1EdYyHY1VioFlbjwnztvIKgybPC+mlD9LrLFueidS7"
{{- end }}
