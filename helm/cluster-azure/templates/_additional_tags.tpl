{{- define "additional-tags" -}}
{{- $tags := .Values.providerSpecific.additionalResourceTags | default dict }}
additionalTags:
  giantswarm-cluster: {{ include "resource.default.name" . }}
  {{- if $tags }}
  {{- toYaml $tags | nindent 2 }}
  {{- end -}}
{{- end -}}
