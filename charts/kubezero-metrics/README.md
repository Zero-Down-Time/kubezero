# kubezero-metrics

![Version: 0.1.4](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Umbrella Chart for prometheus-operator

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-charts.storage.googleapis.com/ | prometheus-adapter | 2.5.0 |
| https://kubernetes-charts.storage.googleapis.com/ | prometheus-operator | 9.3.1 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| grafana.istio.enabled | bool | `false` |  |
| grafana.istio.gateway | string | `"istio-system/ingressgateway"` |  |
| grafana.istio.ipBlocks | list | `[]` |  |
| grafana.istio.url | string | `""` |  |
| prometheus-adapter.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| prometheus-adapter.prometheus.url | string | `"http://metrics-prometheus-operato-prometheus"` |  |
| prometheus-adapter.rules.default | bool | `false` |  |
| prometheus-adapter.rules.resource.cpu.containerLabel | string | `"container"` |  |
| prometheus-adapter.rules.resource.cpu.containerQuery | string | `"sum(irate(container_cpu_usage_seconds_total{<<.LabelMatchers>>,container!=\"POD\",container!=\"\",pod!=\"\"}[5m])) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.cpu.nodeQuery | string | `"sum(1 - irate(node_cpu_seconds_total{mode=\"idle\"}[5m]) * on(namespace, pod) group_left(node) node_namespace_pod:kube_pod_info:{<<.LabelMatchers>>}) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.cpu.resources.overrides.namespace.resource | string | `"namespace"` |  |
| prometheus-adapter.rules.resource.cpu.resources.overrides.node.resource | string | `"node"` |  |
| prometheus-adapter.rules.resource.cpu.resources.overrides.pod.resource | string | `"pod"` |  |
| prometheus-adapter.rules.resource.memory.containerLabel | string | `"container"` |  |
| prometheus-adapter.rules.resource.memory.containerQuery | string | `"sum(container_memory_working_set_bytes{<<.LabelMatchers>>,container!=\"POD\",container!=\"\",pod!=\"\"}) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.memory.nodeQuery | string | `"sum(node_memory_MemTotal_bytes{job=\"node-exporter\",<<.LabelMatchers>>} - node_memory_MemAvailable_bytes{job=\"node-exporter\",<<.LabelMatchers>>}) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.memory.resources.overrides.namespace.resource | string | `"namespace"` |  |
| prometheus-adapter.rules.resource.memory.resources.overrides.node.resource | string | `"node"` |  |
| prometheus-adapter.rules.resource.memory.resources.overrides.pod.resource | string | `"pod"` |  |
| prometheus-adapter.rules.resource.window | string | `"5m"` |  |
| prometheus-adapter.tolerations[0].effect | string | `"NoSchedule"` |  |
| prometheus-adapter.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| prometheus-operator.alertmanager.enabled | bool | `false` |  |
| prometheus-operator.coreDns.enabled | bool | `true` |  |
| prometheus-operator.defaultRules.create | bool | `true` |  |
| prometheus-operator.grafana.enabled | bool | `true` |  |
| prometheus-operator.grafana.initChownData.enabled | bool | `false` |  |
| prometheus-operator.grafana.persistence.enabled | bool | `true` |  |
| prometheus-operator.grafana.persistence.size | string | `"4Gi"` |  |
| prometheus-operator.grafana.persistence.storageClassName | string | `"ebs-sc-gp2-xfs"` |  |
| prometheus-operator.grafana.plugins[0] | string | `"grafana-piechart-panel"` |  |
| prometheus-operator.grafana.service.portName | string | `"http-grafana"` |  |
| prometheus-operator.grafana.testFramework.enabled | bool | `false` |  |
| prometheus-operator.kubeApiServer.enabled | bool | `true` |  |
| prometheus-operator.kubeControllerManager.enabled | bool | `true` |  |
| prometheus-operator.kubeControllerManager.service.port | int | `10257` |  |
| prometheus-operator.kubeControllerManager.service.targetPort | int | `10257` |  |
| prometheus-operator.kubeControllerManager.serviceMonitor.https | bool | `true` |  |
| prometheus-operator.kubeControllerManager.serviceMonitor.insecureSkipVerify | bool | `true` |  |
| prometheus-operator.kubeDns.enabled | bool | `false` |  |
| prometheus-operator.kubeEtcd.enabled | bool | `true` |  |
| prometheus-operator.kubeEtcd.service.port | int | `2381` |  |
| prometheus-operator.kubeEtcd.service.targetPort | int | `2381` |  |
| prometheus-operator.kubeProxy.enabled | bool | `true` |  |
| prometheus-operator.kubeScheduler.enabled | bool | `true` |  |
| prometheus-operator.kubeScheduler.service.port | int | `10259` |  |
| prometheus-operator.kubeScheduler.service.targetPort | int | `10259` |  |
| prometheus-operator.kubeScheduler.serviceMonitor.https | bool | `true` |  |
| prometheus-operator.kubeScheduler.serviceMonitor.insecureSkipVerify | bool | `true` |  |
| prometheus-operator.kubeStateMetrics.enabled | bool | `true` |  |
| prometheus-operator.kubelet.enabled | bool | `true` |  |
| prometheus-operator.kubelet.serviceMonitor.cAdvisor | bool | `true` |  |
| prometheus-operator.nodeExporter.enabled | bool | `true` |  |
| prometheus-operator.nodeExporter.serviceMonitor.relabelings[0].action | string | `"replace"` |  |
| prometheus-operator.nodeExporter.serviceMonitor.relabelings[0].regex | string | `"^(.*)$"` |  |
| prometheus-operator.nodeExporter.serviceMonitor.relabelings[0].replacement | string | `"$1"` |  |
| prometheus-operator.nodeExporter.serviceMonitor.relabelings[0].separator | string | `";"` |  |
| prometheus-operator.nodeExporter.serviceMonitor.relabelings[0].sourceLabels[0] | string | `"__meta_kubernetes_pod_node_name"` |  |
| prometheus-operator.nodeExporter.serviceMonitor.relabelings[0].targetLabel | string | `"node"` |  |
| prometheus-operator.prometheus.enabled | bool | `true` |  |
| prometheus-operator.prometheus.prometheusSpec.portName | string | `"http-prometheus"` |  |
| prometheus-operator.prometheus.prometheusSpec.resources.limits.cpu | string | `"1000m"` |  |
| prometheus-operator.prometheus.prometheusSpec.resources.limits.memory | string | `"3Gi"` |  |
| prometheus-operator.prometheus.prometheusSpec.resources.requests.cpu | string | `"500m"` |  |
| prometheus-operator.prometheus.prometheusSpec.resources.requests.memory | string | `"1Gi"` |  |
| prometheus-operator.prometheus.prometheusSpec.retention | string | `"8d"` |  |
| prometheus-operator.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| prometheus-operator.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage | string | `"16Gi"` |  |
| prometheus-operator.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName | string | `"ebs-sc-gp2-xfs"` |  |
| prometheus-operator.prometheusOperator.admissionWebhooks.enabled | bool | `false` |  |
| prometheus-operator.prometheusOperator.createCustomResource | bool | `true` |  |
| prometheus-operator.prometheusOperator.enabled | bool | `true` |  |
| prometheus-operator.prometheusOperator.manageCrds | bool | `false` |  |
| prometheus-operator.prometheusOperator.namespaces.additional[0] | string | `"kube-system"` |  |
| prometheus-operator.prometheusOperator.namespaces.additional[1] | string | `"logging"` |  |
| prometheus-operator.prometheusOperator.namespaces.releaseNamespace | bool | `true` |  |
| prometheus-operator.prometheusOperator.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| prometheus-operator.prometheusOperator.tlsProxy.enabled | bool | `false` |  |
| prometheus-operator.prometheusOperator.tolerations[0].effect | string | `"NoSchedule"` |  |
| prometheus-operator.prometheusOperator.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| prometheus.istio.enabled | bool | `false` |  |
| prometheus.istio.gateway | string | `"istio-system/ingressgateway"` |  |
| prometheus.istio.url | string | `""` |  |

# Dashboards

## Etcs
- https://grafana.com/grafana/dashboards/3070

## ElasticSearch
- https://grafana.com/grafana/dashboards/266

