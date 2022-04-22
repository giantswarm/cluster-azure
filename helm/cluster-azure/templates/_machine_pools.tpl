{{- define "machine-pools" }}
{{ range .Values.machinePools }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachinePool
metadata:
  annotations:
    machine-pool.giantswarm.io/name: {{ include "resource.default.name" $ }}-{{ .name }}
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  clusterName: {{ include "resource.default.name" $ }}
  replicas: {{ .minSize }}
  template:
    spec:
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfig
          name: {{ include "resource.default.name" $ }}-{{ .name }}
      clusterName: {{ include "resource.default.name" $ }}
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSMachinePool
        name: {{ include "resource.default.name" $ }}-{{ .name }}
      version: {{ $.Values.kubernetesVersion }}
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSMachinePool
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  availabilityZones: {{ .availabilityZones | default (include "aws-availability-zones" .) }}
  awsLaunchTemplate:
    ami: {}
    iamInstanceProfile: {{ include "resource.default.name" $ }}-nodes-{{ .name }}
    instanceType: {{ .instanceType }}
    rootVolume:
      size: {{ .rootVolumeSizeGB }}
      type: gp3
    imageLookupBaseOS: flatcar-stable
    imageLookupOrg: "{{ $.Values.flatcarAWSAccount }}"
    sshKeyName: ""
  minSize: {{ .minSize }}
  maxSize: {{ .maxSize }}
  mixedInstancesPolicy:
    instancesDistribution:
      onDemandAllocationStrategy: prioritized
      onDemandBaseCapacity: 0
      onDemandPercentageAboveBaseCapacity: 100
      spotAllocationStrategy: lowest-price
---
apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
kind: KubeadmConfig
metadata:
  labels:
    giantswarm.io/machine-pool: {{ include "resource.default.name" $ }}-{{ .name }}
    {{- include "labels.common" $ | nindent 4 }}
  name: {{ include "resource.default.name" $ }}-{{ .name }}
  namespace: {{ $.Release.Namespace }}
spec:
  joinConfiguration:
    discovery: {}
    nodeRegistration:
      kubeletExtraArgs:
        cloud-provider: aws
        healthz-bind-address: 0.0.0.0
        image-pull-progress-deadline: 1m
        node-labels: role=worker,giantswarm.io/machine-pool={{ include "resource.default.name" $ }}-{{ .name }},{{- join "," .customNodeLabels }}
        v: "2"
      name: ${COREOS_EC2_HOSTNAME}
  format: ignition
  ignition:
    containerLinuxConfig:
      additionalConfig: |
        storage:
          links:
          # For some reason enabling services via systemd.units doesn't work on Flatcar CAPI AMIs.
          - path: /etc/systemd/system/multi-user.target.wants/coreos-metadata.service
            target: /usr/lib/systemd/system/coreos-metadata.service
          - path: /etc/systemd/system/multi-user.target.wants/kubeadm.service
            target: /etc/systemd/system/kubeadm.service
        systemd:
          units:
          - name: kubeadm.service
            dropins:
            - name: 10-flatcar.conf
              contents: |
                [Unit]
                # kubeadm must run after coreos-metadata populated /run/metadata directory.
                Requires=coreos-metadata.service
                After=coreos-metadata.service
                [Service]
                # Ensure kubeadm service has access to kubeadm binary in /opt/bin on Flatcar.
                Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/bin
                # To make metadata environment variables available for pre-kubeadm commands.
                EnvironmentFile=/run/metadata/*
  preKubeadmCommands:
  - envsubst < /etc/kubeadm.yml > /etc/kubeadm.yml.tmp
  - mv /etc/kubeadm.yml.tmp /etc/kubeadm.yml
  - 'files="/etc/ssh/trusted-user-ca-keys.pem /etc/ssh/sshd_config"; for f in $files; do tmpFile=$(mktemp); cat "${f}" | base64 -d > ${tmpFile}; if [ "$?" -eq 0 ]; then mv ${tmpFile} ${f};fi;  done;'
  - systemctl restart sshd
  files:
  {{- include "sshFiles" $ | nindent 4 }}
  users:
  {{- include "sshUsers" . | nindent 2 }}
---
{{ end }}
{{- end -}}
