kubezero-metrics
================
KubeZero Umbrella Chart for prometheus-operator

Current chart version is `0.0.1`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-charts.storage.googleapis.com/ | prometheus-operator | 9.3.0 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| prometheus-operator.alertmanager.enabled | bool | `false` |  |
| prometheus-operator.coreDns.enabled | bool | `false` |  |
| prometheus-operator.defaultRules.create | bool | `false` |  |
| prometheus-operator.grafana.enabled | bool | `false` |  |
| prometheus-operator.kubeApiServer.enabled | bool | `false` |  |
| prometheus-operator.kubeControllerManager.enabled | bool | `false` |  |
| prometheus-operator.kubeDns.enabled | bool | `false` |  |
| prometheus-operator.kubeEtcd.enabled | bool | `false` |  |
| prometheus-operator.kubeProxy.enabled | bool | `false` |  |
| prometheus-operator.kubeScheduler.enabled | bool | `false` |  |
| prometheus-operator.kubeStateMetrics.enabled | bool | `false` |  |
| prometheus-operator.kubelet.enabled | bool | `false` |  |
| prometheus-operator.nodeExporter.enabled | bool | `false` |  |
| prometheus-operator.prometheus.enabled | bool | `false` |  |
| prometheus-operator.prometheusOperator.admissionWebhooks.enabled | bool | `false` |  |
| prometheus-operator.prometheusOperator.createCustomResource | bool | `false` |  |
| prometheus-operator.prometheusOperator.enabled | bool | `true` |  |
| prometheus-operator.prometheusOperator.namespaces.additional[0] | string | `"kube-system"` |  |
| prometheus-operator.prometheusOperator.namespaces.releaseNamespace | bool | `true` |  |
| prometheus-operator.prometheusOperator.serviceMonitor.selfMonitor | bool | `false` |  |
| prometheus-operator.prometheusOperator.tlsProxy.enabled | bool | `false` |  |
