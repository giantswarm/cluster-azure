{{- define "machine-deployment" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-md
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: 3
  selector:
    matchLabels: null
  template:
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: {{ include "resource.default.name" $ }}-md
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AzureMachineTemplate
        name: {{ include "resource.default.name" $ }}-md
      version: {{ .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-md
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      {{- if .Values.vmIdentity.type }}
      identity: {{ .Values.vmIdentity.type }}
      {{- if gt (len .Values.vmIdentity.userAssignedIdentitiesIds) 0 }}
      userAssignedIdentities:
      {{- range $id := .Values.vmIdentity.userAssignedIdentitiesIds }}
        - providerID: {{ $id }}
      {{- end }}
      {{- end }}
      {{- end }}
      osDisk:
        diskSizeGB: 128
        osType: Linux
      sshPublicKey: ""
      vmSize: Standard_D2s_v3
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  labels:
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-md
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      files:
        - contentFrom:
            secret:
              key: worker-node-azure.json
              name: {{ include "resource.default.name" $ }}-control-plane-azure-json
          owner: root:root
          path: /etc/kubernetes/azure.json
          permissions: "0644"
      joinConfiguration:
        nodeRegistration:
          kubeletExtraArgs:
            azure-container-registry-config: /etc/kubernetes/azure.json
            cloud-config: /etc/kubernetes/azure.json
            cloud-provider: external
            feature-gates: CSIMigrationAzureDisk=true
          name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
      preKubeadmCommands: []
{{ end }}