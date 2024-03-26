{{- define "additional-tags" -}}
{{- $tags := .tags | default list }}
{{- if gt (len $tags) 0 }}
additionalTags:
  {{- range $tag := $tags }}
  {{ $tag.name }}: {{ $tag.value | quote -}}
  {{- end -}}
{{- end -}}
{{- end -}}
