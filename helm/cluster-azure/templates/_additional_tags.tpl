{{- define "additional-tags" -}}
{{- $tags := .tags | default dict }}
{{- if $tags }}
additionalTags:
  {{- toYaml $tags | nindent 2 }}
{{- end -}}
{{- end -}}
