{{- define "machine-pools" -}}
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  labels:
  name: clusterclass-v0.1.0-kubeadm-config-template
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      files:
        - contentFrom:
            secret:
              key: worker-node-azure.json
              name: static-marioc3-azure-json
          owner: root:root
          path: /etc/kubernetes/azure.json
          permissions: "0644"
      joinConfiguration:
        nodeRegistration:
          kubeletExtraArgs:
            cloud-config: /etc/kubernetes/azure.json
            cloud-provider: external
          name: '{{ `{{ ds.meta_data.local_hostname }}` }}'
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  name: clusterclass-v0.1.1-azure-machine-template-worker
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      osDisk:
        osType: Linux
      sshPublicKey: {{ .Values.sshSSOPublicKey | b64enc }}
      vmSize: Standard_D2s_v3
{{- end -}}
