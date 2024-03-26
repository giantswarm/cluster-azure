{{- define "additional-tags" -}}
{{- $tags := .Values.providerSpecific.additionalResourceTags | default dict }}
additionalTags:
  giantswarm.io/cluster: {{ include "resource.default.name" . }}
  {{- if $tags }}
  {{- toYaml $tags | nindent 2 }}
  {{- end -}}
{{- end -}}
