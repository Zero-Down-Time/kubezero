{{- /* Feature gates for all control plane components */ -}}
{{- /* Issues: MemoryQoS */ -}}
{{- /* v1.28: PodAndContainerStatsFromCRI still not working */ -}}
{{- /* v1.28: UnknownVersionInteroperabilityProxy requires StorageVersionAPI which is still alpha in 1.30 */ -}}
{{- /* v1.29: remove/beta SidecarContainers */ -}}
{{- /* v1.30: remove/beta KubeProxyDrainingTerminatingNodes */ -}}
{{- define "kubeadm.featuregates" }}
{{- $gates := list "CustomCPUCFSQuotaPeriod" "SidecarContainers" "KubeProxyDrainingTerminatingNodes" }}
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
