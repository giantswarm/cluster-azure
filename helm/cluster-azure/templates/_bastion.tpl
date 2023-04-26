{{- define "bastion-machine-identity" -}}
{{/* We need to set a role, set a very low priviliged for now (Workbook Reader) and TODO Look into this */}}
identity: SystemAssigned
systemAssignedIdentityRole:
  scope: /subscriptions/{{ $.Values.providerSpecific.subscriptionId }}/resourceGroups/{{ include "resource.default.name" $ }}
  definitionID: /subscriptions/{{ $.Values.providerSpecific.subscriptionId }}/providers/Microsoft.Authorization/roleDefinitions/b279062a-9be3-42a0-92ae-8b3cf002ec4d
{{- end -}}

{{- define "bastion-machine-spec" -}}
image:
  computeGallery:
    gallery: {{  $.Values.internal.image.gallery }}
    name: {{ include "flatcarImageName" $ }}
    version: {{ $.Values.internal.image.version }}
osDisk:
  diskSizeGB: {{ .spec.rootVolumeSizeGB }}
  managedDisk:
    storageAccountType: Premium_LRS
  osType: Linux
sshPublicKey: {{ include "fake-rsa-ssh-key" $ | b64enc }}
{{- if (hasKey $.spec "subnetName") }}
subnetName: {{ $.spec.subnetName }}
{{- else if (eq .Values.connectivity.network.mode "private") }}
subnetName: {{ include "network.subnets.nodes.name" $ }}
{{- else }}
subnetName: {{ include "network.subnets.controlPlane.name" $ }}
{{- end }}
allocatePublicIP: {{ ternary false true (eq .Values.connectivity.network.mode "private" ) }}
vmSize: {{ .spec.instanceType }}
{{- end -}}

{{- define "bastion-machine-kubeadmconfig-spec" -}}
format: ignition
ignition:
  containerLinuxConfig:
    additionalConfig: |
      systemd:
        units:
        - name: kubeadm.service
          mask: true
joinConfiguration:
files:
{{- include "sshFilesBastion" $ | nindent 2 }}
preKubeadmCommands:
  - systemctl restart sshd
  - sleep infinity
postKubeadmCommands: []
users:
{{- include "sshUsers" . | nindent 2 }}
{{- end }}

{{- define "bastion-machine-deployment" -}}
{{ $spec := merge (dict "name" "bastion" "rootVolumeSizeGB" "30" ) $.Values.connectivity.bastion }}
{{ $data := dict "spec" $spec "type" "bastionMachineDeployment" "Values" $.Values "Release" $.Release "Files" $.Files "Template" $.Template }}
{{ $kubeAdmConfigTemplateHash := dict "hash" ( include "hash" (dict "data" (include "bastion-machine-kubeadmconfig-spec" $data) "global" $) ) }}
{{ $azureMachineTemplateHash := dict "hash" ( include "hash" (dict "data" ( dict "spec" (include "bastion-machine-spec" $data) "identity" (include "bastion-machine-identity" $data) ) "global" $) ) }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  annotations:
    machine-deployment.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ $spec.name }}
  labels:
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ $spec.name }}
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $spec.name }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: 1
  selector:
    matchLabels: null
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: {{ include "resource.default.name" $ }}-{{ $spec.name }}-{{ $kubeAdmConfigTemplateHash.hash }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AzureMachineTemplate
        name: {{ include "resource.default.name" $ }}-{{ $spec.name }}-{{ $azureMachineTemplateHash.hash }}
      version: {{ $.Values.internal.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ $spec.name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $spec.name }}-{{ $azureMachineTemplateHash.hash }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      {{- include "bastion-machine-identity" $data | nindent 6}}
      {{- include "bastion-machine-spec" $data | nindent 6}}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    giantswarm.io/machine-deployment: {{ include "resource.default.name" $ }}-{{ $spec.name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ $spec.name }}-{{ $kubeAdmConfigTemplateHash.hash }}
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec: {{- include "bastion-machine-kubeadmconfig-spec" (merge $data $azureMachineTemplateHash ) | nindent 6 }}
{{- end -}}
