{{- define "machine-deployment" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  name: {{ include "resource.default.name" $ }}-md
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: 0
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
      version: v1.22.0
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  name: {{ include "resource.default.name" $ }}-md
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      osDisk:
        diskSizeGB: 128
        osType: Linux
      sshPublicKey: ""
      vmSize: Standard_D2s_v3
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  name: {{ include "resource.default.name" $ }}-md
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      files:
        - contentFrom:
            secret:
              key: worker-node-azure.json
              name: {{ include "resource.default.name" $ }}-md-0-azure-json
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
{{ end }}