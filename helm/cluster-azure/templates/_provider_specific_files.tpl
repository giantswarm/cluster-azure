{{- define "provider-specific-files" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "resource.default.name" $ }}-provider-specific-files
  namespace: {{ $.Release.Namespace | quote }}
data:
  update_etc_hosts.sh: {{ tpl ($.Files.Get "files/opt/update_etc_hosts.sh") $ | b64enc | quote }}
type: Opaque
{{ end }}
