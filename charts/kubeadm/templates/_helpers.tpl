{{- /* Feature gates for all control plane components */ -}}
{{- /* Issues: "MemoryQoS" */ -}}
{{- /* v1.30?: "NodeSwap" */ -}}
{{- /* v1.29: remove/beta now "SidecarContainers" */ -}}
{{- /* v1.28: "PodAndContainerStatsFromCRI" still not working */ -}}
{{- define "kubeadm.featuregates" }}
{{- $gates := list "CustomCPUCFSQuotaPeriod" "SidecarContainers" }}
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
