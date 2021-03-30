{{- /*
Feature gates for all control plane components
*/ -}}
{{- define "kubeadm.featuregates" -}}
{{- $gates := dict "DefaultPodTopologySpread" "true" "CustomCPUCFSQuotaPeriod" "true" "GenericEphemeralVolume" "true" }}
{{- if eq .platform "aws" }}
{{- $gates = merge $gates ( dict "CSIMigrationAWS" "true" "CSIMigrationAWSComplete" "true") }}
{{- end }}
{{- if eq .return "csv" }}
{{- range $key, $val := $gates }}
{{- $key }}={{- $val }},
{{- end }}
{{- else }}
{{- range $key, $val := $gates }}
  {{ $key }}: {{ $val }}
{{- end }}
{{- end }}
{{- end -}}
