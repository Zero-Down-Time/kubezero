{{- /* Feature gates for all control plane components */ -}}
{{- define "kubeadm.featuregates" -}}
{{- $gates := list "CustomCPUCFSQuotaPeriod" "GenericEphemeralVolume" "InTreePluginAWSUnregister" "InTreePluginAzureDiskUnregister" "InTreePluginAzureFileUnregister" "InTreePluginGCEUnregister" "InTreePluginOpenStackUnregister" }}
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


{{- /* Etcd default initial cluster */ -}}
{{- define "kubeadm.etcd.initialCluster" -}}
{{- if .initialCluster -}}
{{ .initialCluster }}
{{- else -}}
{{ .nodeName }}=https://{{ .nodeName }}:2380
{{- end -}}
{{- end -}}
