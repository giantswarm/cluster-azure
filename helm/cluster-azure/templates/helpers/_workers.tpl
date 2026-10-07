{{- define "workers-azuremachinetemplate-spec" -}}
{{- include "renderIdentityConfiguration" $ }}
{{- /* Get image name components. */}}
{{- $osName := include "cluster.os.name" $ }}
{{- $osReleaseChannel := include "cluster.os.releaseChannel" $ }}
{{- $osVersion := include "cluster.os.version" $ }}
{{- $kubernetesVersion := include "cluster.component.kubernetes.version" $ }}
{{- $osToolingVersion := include "cluster.os.tooling.version" $ }}
image:
  computeGallery:
    gallery: gsCapzFlatcar-41c2d140-ac44-4d8b-b7e1-7b2f1ddbe4d0
    name: {{ $osName }}-{{ $osReleaseChannel }}-{{ $osVersion }}-kube-{{ $kubernetesVersion }}-tooling-{{ $osToolingVersion }}-gs
    version: "{{ $osVersion }}"
osDisk:
  diskSizeGB: {{ .nodePool.config.rootVolumeSizeGB | default 50 }}
  managedDisk:
    storageAccountType: Premium_LRS
  osType: Linux
securityProfile:
  encryptionAtHost: {{ .nodePool.config.encryptionAtHost | default false }}
sshPublicKey: {{ include "fake-rsa-ssh-key" $ | b64enc }}
vmSize: {{ .nodePool.config.instanceType | default "Standard_D4s_v5" }}
{{- if ( include "network.subnets.nodes.name" $ ) }}
subnetName: {{ include "network.subnets.nodes.name" $ }}
{{- end }}
{{- end -}}

{{/*
# Azure MAchine spec requires us to pass a key anyway and this key MUST be an RSA one - https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/ed25519-ssh-keys
# This is not the key we actually use for ssh
*/}}
{{- define "fake-rsa-ssh-key" -}}
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl9dTHYnfaRf75FTwv2lj5RAvBf4R9o39J5z+Pyf101cNDRSDmbJM1tsadowrvPg8IMqPN2WO77Lbiam3L+WQDxhCCR87mW9qDJa4aVHJZul4GLA+Ij85rOq1Uy2oIAXtuaipVU5H2IdUiDrPZ+Dy9YxsZfWp+3+8WI/OVyxhIwQpb4PN3sbwiSJDF2M91exwnAiHysE3BS0Dk75OMGuzZOmWQ0dnDW0Kazor06stYaIAbeSlf4MQlUE9KcoPMjeBl5GWJVy5nbrm5yl4P+VI6npp8rcFB9YXH9q3nmtkxJF1EdYyHY1VioFlbjwnztvIKgybPC+mlD9LrLFueidS7
{{- end }}
