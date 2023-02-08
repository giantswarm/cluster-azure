{{- define "bastion-machine-identity" -}}
{{- if .Values.enablePerClusterIdentity -}}
identity: UserAssigned
userAssignedIdentities:
  - providerID: {{ include "vmUaIdentityPrefix" $ }}-nodes {{/* TODO Review this identity, with SA Identity we can set it to empty */}}
{{ end -}}
{{- end -}}

{{- define "bastion-machine-spec" -}}
osDisk:
  diskSizeGB: {{ .spec.rootVolumeSizeGB }}
  managedDisk:
    storageAccountType: Premium_LRS
  osType: Linux
sshPublicKey: {{ include "fake-rsa-ssh-key" $ | b64enc }}
subnetName: {{ $.spec.subnetName | default (ternary "node-subnet" "control-plane-subnet" (eq .Values.network.mode "private" )) }}
allocatePublicIP: {{ ternary false true (eq .Values.network.mode "private" ) }}
vmSize: {{ .spec.instanceType }}
{{- end -}}

{{- define "bastion-machine-kubeadmconfig-spec" -}}
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
{{ $spec := merge (dict "name" "bastion" "rootVolumeSizeGB" "30" ) $.Values.bastion }}
{{ $data := dict "spec" $spec "type" "bastionMachineDeployment" "Values" $.Values "Release" $.Release "Files" $.Files "Template" $.Template }}
{{ $kubeAdmConfigTemplateHash := dict "hash" ( include "hash" (dict "data" (include "bastion-machine-kubeadmconfig-spec" $data) "global" $) ) }}
{{ $azureMachineTemplateHash := dict "hash" ( include "hash" (dict "data" (include "bastion-machine-spec" $data) "global" $) ) }}
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
      version: {{ $.Values.kubernetesVersion }}
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