{{- define "controlplane-azuremachinetemplate-spec" -}}
{{ $identity := dict "type" "controlPlane" "Values" $.Values "Release" $.Release }}
{{- include "renderIdentityConfiguration" $identity }}
{{- $kubernetesVersion := include "cluster.component.kubernetes.version" $ }}
{{- $osImageVersion := include "cluster.component.flatcar.version" $ }}
image:
  computeGallery:
    gallery: gsCapzFlatcar-41c2d140-ac44-4d8b-b7e1-7b2f1ddbe4d0
    name: {{ include "flatcarImageName" $ }}
    version: {{ $osImageVersion }}
dataDisks:
  - diskSizeGB: {{ $.Values.global.controlPlane.etcdVolumeSizeGB }}
    lun: 0
    nameSuffix: etcddisk
  - diskSizeGB: {{ $.Values.global.controlPlane.containerdVolumeSizeGB }}
    lun: 1
    nameSuffix: containerddisk
  - diskSizeGB: {{ $.Values.global.controlPlane.kubeletVolumeSizeGB }}
    lun: 2
    nameSuffix: kubeletdisk
osDisk:
  diskSizeGB: {{ $.Values.global.controlPlane.rootVolumeSizeGB }}
  osType: Linux
securityProfile:
  encryptionAtHost: {{ $.Values.global.controlPlane.encryptionAtHost }}
sshPublicKey: {{ include "fake-rsa-ssh-key" $ | b64enc }}
vmSize: {{ $.Values.global.controlPlane.instanceType }}
{{- if ( include "network.subnets.controlPlane.name" $ ) }}
subnetName: {{ include "network.subnets.controlPlane.name" $ }}
{{- end }}
{{- end }}

{{- define "control-plane" }}
{{- $osImageVersion := include "cluster.component.flatcar.version" $ }}
{{- $osImageVariant := include "cluster.component.flatcar.variant" $ }}
{{- $kubernetesVersion := include "cluster.component.kubernetes.version" $ }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: control-plane
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-control-plane-{{ include "hash" (dict "data" (include "controlplane-azuremachinetemplate-spec" $) "global" .) }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        {{- include "labels.common" $ | nindent 8 }}
    spec: {{- include "controlplane-azuremachinetemplate-spec" $ | nindent 6 }}
{{- end -}}
