{{- /*
Common set of labels
*/ -}}
{{- define "kubezero-lib.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: kubezero
{{- end -}}
