{{- /*
Common set of labels
*/ -}}
{{- define "kubezero-lib.labels" -}}
app.kubernetes.io/name: {{ .name }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: kubezero
{{- end -}}
