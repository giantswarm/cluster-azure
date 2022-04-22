{{- define "bastion" }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ .Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .Values.bastion.replicas }}
  selector:
    matchLabels:
      cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
      cluster.x-k8s.io/deployment-name: {{ include "resource.default.name" $ }}-bastion
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        cluster.x-k8s.io/cluster-name: {{ include "resource.default.name" $ }}
        cluster.x-k8s.io/deployment-name: {{ include "resource.default.name" $ }}-bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: {{ include "resource.default.name" $ }}-bastion
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSMachineTemplate
        name: {{ include "resource.default.name" $ }}-bastion
      version: {{ .Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureMachineTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ .Release.Namespace }}
spec:
  template:
    metadata:
      labels:
        cluster.x-k8s.io/role: bastion
        {{- include "labels.common" $ | nindent 8 }}
    spec:
      acceleratedNetworking: false
      allocatePublicIP: true
      identity: None
      osDisk:
        cachingType: None
        diskSizeGB: 30
        osType: Linux
      sshPublicKey: c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCQVFDdWxQY2NSRnpNazhMb1puK08yaFRrSTZvUHdJNFJIalVDYXV2ckY1STluR3I2VmpIdktRVDNiMGpUeGlwL2p6UFJGaFJ0enhPZTRkUjdGdjYwQm1relFENFBwZTdmblhTbUMwQjhZbncyeXYwUHlMZDY5Slk4QmJ4V3VsM0x4UHRmREd4OEZXSWlRMnFKTU1UMW5jOWNRWFJVd1BuL3U4VVpBTk42WkVnRk1HQ2I1TFBnQ0UxdFQyVGdMOGh6L2JUdTNPT2NXVzJTTHYvVnVyK1NweURwbkhvOVpJcTlJTGdLYXJWc2UwUXlyTCtyRWZJVDBUcXlaUGJUMWtVOEZ1a3JQTmx2UktKT21aYlVVbkJzWWhhSHBRMlV5ZGlxSmthSkw3cFhEakM5VzRHM2thdU5iZXVVUHpxZVdDeklkZnpTb0FaOExTNTJndVdiM0tWc2JPQU4K
      subnetName: {{ include "resource.default.name" $ }}-bastion
      vmSize: {{ .Values.bastion.vmSize }}
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfigTemplate
metadata:
  labels:
    cluster.x-k8s.io/role: bastion
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-bastion
  namespace: {{ $.Release.Namespace }}
spec:
  template:
    spec:
      preKubeadmCommands:
      - systemctl restart ssh
      - sleep infinity
      files:
      {{- include "sshFilesBastion" $ | nindent 6 }}
      users:
      {{- include "sshUsers" . | nindent 6 }}
{{- end -}}
