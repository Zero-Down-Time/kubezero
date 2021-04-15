{{- /*
Feature gates for all control plane components
*/ -}}
{{- define "kubeadm.featuregates" -}}
{{- $gates := list "CustomCPUCFSQuotaPeriod" "GenericEphemeralVolume" "CSIMigrationAWSComplete" "CSIMigrationAzureDiskComplete" "CSIMigrationAzureFileComplete" "CSIMigrationGCEComplete" "CSIMigrationOpenStackComplete" "CSIMigrationvSphereComplete" }}
{{- if eq .return "csv" }}
{{- range $key := $gates }}
{{- $key }}=true,
{{- end }}
{{- else }}
{{- range $key := $gates }}
  {{ $key }}: true
{{- end }}
{{- end }}
{{- end -}}
