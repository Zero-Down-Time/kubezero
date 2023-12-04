{{- /* Feature gates for all control plane components */ -}}
{{- /* ToAdd: "PodAndContainerStatsFromCRI" */ -}}
{{- /* Issues: "MemoryQoS" */ -}}
{{- /* v1.28: "NodeSwap" */ -}}
{{- define "kubeadm.featuregates" }}
{{- $gates := list "CustomCPUCFSQuotaPeriod" }}
{{- if eq .return "csv" }}
{{- range $key := $gates }}
{{- $key }}=true,
{{- end }}
{{- else }}
{{- range $key := $gates }}
{{ $key }}: true
{{- end }}
{{- end }}
{{- end }}


{{- /* Etcd default initial cluster */ -}}
{{- define "kubeadm.etcd.initialCluster" -}}
{{- if .initialCluster -}}
{{ .initialCluster }}
{{- else -}}
{{ .nodeName }}=https://{{ .nodeName }}:2380
{{- end -}}
{{- end -}}
