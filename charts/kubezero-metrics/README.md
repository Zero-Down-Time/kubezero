# kubezero-metrics

![Version: 0.3.1](https://img.shields.io/badge/Version-0.3.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| https://prometheus-community.github.io/helm-charts | kube-prometheus-stack | 12.3.0 |
| https://prometheus-community.github.io/helm-charts | prometheus-adapter | 2.7.1 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| istio.alertmanager.destination | string | `"metrics-kube-prometheus-st-alertmanager"` |  |
| istio.alertmanager.enabled | bool | `false` |  |
| istio.alertmanager.gateway | string | `"istio-ingress/ingressgateway"` |  |
| istio.alertmanager.ipBlocks | list | `[]` |  |
| istio.alertmanager.url | string | `""` |  |
| istio.grafana.destination | string | `"metrics-grafana"` |  |
| istio.grafana.enabled | bool | `false` |  |
| istio.grafana.gateway | string | `"istio-ingress/ingressgateway"` |  |
| istio.grafana.ipBlocks | list | `[]` |  |
| istio.grafana.url | string | `""` |  |
| istio.prometheus.destination | string | `"metrics-kube-prometheus-st-prometheus"` |  |
| istio.prometheus.enabled | bool | `false` |  |
| istio.prometheus.gateway | string | `"istio-ingress/ingressgateway"` |  |
| istio.prometheus.ipBlocks | list | `[]` |  |
| istio.prometheus.url | string | `""` |  |
| kube-prometheus-stack.alertmanager.alertmanagerSpec.logFormat | string | `"json"` |  |
| kube-prometheus-stack.alertmanager.enabled | bool | `false` |  |
| kube-prometheus-stack.coreDns.enabled | bool | `true` |  |
| kube-prometheus-stack.defaultRules.create | bool | `true` |  |
| kube-prometheus-stack.grafana.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana.initChownData.enabled | bool | `false` |  |
| kube-prometheus-stack.grafana.persistence.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana.persistence.size | string | `"4Gi"` |  |
| kube-prometheus-stack.grafana.persistence.storageClassName | string | `"ebs-sc-gp2-xfs"` |  |
| kube-prometheus-stack.grafana.plugins[0] | string | `"grafana-piechart-panel"` |  |
| kube-prometheus-stack.grafana.service.portName | string | `"http-grafana"` |  |
| kube-prometheus-stack.grafana.testFramework.enabled | bool | `false` |  |
| kube-prometheus-stack.kube-state-metrics.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| kube-prometheus-stack.kube-state-metrics.tolerations[0].effect | string | `"NoSchedule"` |  |
| kube-prometheus-stack.kube-state-metrics.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| kube-prometheus-stack.kubeApiServer.enabled | bool | `true` |  |
| kube-prometheus-stack.kubeControllerManager.enabled | bool | `true` |  |
| kube-prometheus-stack.kubeControllerManager.service.port | int | `10257` |  |
| kube-prometheus-stack.kubeControllerManager.service.targetPort | int | `10257` |  |
| kube-prometheus-stack.kubeControllerManager.serviceMonitor.https | bool | `true` |  |
| kube-prometheus-stack.kubeControllerManager.serviceMonitor.insecureSkipVerify | bool | `true` |  |
| kube-prometheus-stack.kubeDns.enabled | bool | `false` |  |
| kube-prometheus-stack.kubeEtcd.enabled | bool | `true` |  |
| kube-prometheus-stack.kubeEtcd.service.port | int | `2381` |  |
| kube-prometheus-stack.kubeEtcd.service.targetPort | int | `2381` |  |
| kube-prometheus-stack.kubeProxy.enabled | bool | `true` |  |
| kube-prometheus-stack.kubeScheduler.enabled | bool | `true` |  |
| kube-prometheus-stack.kubeScheduler.service.port | int | `10259` |  |
| kube-prometheus-stack.kubeScheduler.service.targetPort | int | `10259` |  |
| kube-prometheus-stack.kubeScheduler.serviceMonitor.https | bool | `true` |  |
| kube-prometheus-stack.kubeScheduler.serviceMonitor.insecureSkipVerify | bool | `true` |  |
| kube-prometheus-stack.kubeStateMetrics.enabled | bool | `true` |  |
| kube-prometheus-stack.kubelet.enabled | bool | `true` |  |
| kube-prometheus-stack.kubelet.serviceMonitor.cAdvisor | bool | `true` |  |
| kube-prometheus-stack.nodeExporter.enabled | bool | `true` |  |
| kube-prometheus-stack.nodeExporter.serviceMonitor.relabelings[0].action | string | `"replace"` |  |
| kube-prometheus-stack.nodeExporter.serviceMonitor.relabelings[0].regex | string | `"^(.*)$"` |  |
| kube-prometheus-stack.nodeExporter.serviceMonitor.relabelings[0].replacement | string | `"$1"` |  |
| kube-prometheus-stack.nodeExporter.serviceMonitor.relabelings[0].separator | string | `";"` |  |
| kube-prometheus-stack.nodeExporter.serviceMonitor.relabelings[0].sourceLabels[0] | string | `"__meta_kubernetes_pod_node_name"` |  |
| kube-prometheus-stack.nodeExporter.serviceMonitor.relabelings[0].targetLabel | string | `"node"` |  |
| kube-prometheus-stack.prometheus.enabled | bool | `true` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.logFormat | string | `"json"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.portName | string | `"http-prometheus"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.resources.limits.memory | string | `"3Gi"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.resources.requests.cpu | string | `"500m"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.resources.requests.memory | string | `"1Gi"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.retention | string | `"8d"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage | string | `"16Gi"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName | string | `"ebs-sc-gp2-xfs"` |  |
| kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.tolerations[0].effect | string | `"NoSchedule"` |  |
| kube-prometheus-stack.prometheusOperator.admissionWebhooks.patch.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| kube-prometheus-stack.prometheusOperator.enabled | bool | `true` |  |
| kube-prometheus-stack.prometheusOperator.logFormat | string | `"json"` |  |
| kube-prometheus-stack.prometheusOperator.namespaces.additional[0] | string | `"kube-system"` |  |
| kube-prometheus-stack.prometheusOperator.namespaces.additional[1] | string | `"logging"` |  |
| kube-prometheus-stack.prometheusOperator.namespaces.releaseNamespace | bool | `true` |  |
| kube-prometheus-stack.prometheusOperator.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| kube-prometheus-stack.prometheusOperator.tolerations[0].effect | string | `"NoSchedule"` |  |
| kube-prometheus-stack.prometheusOperator.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| prometheus-adapter.enabled | bool | `true` |  |
| prometheus-adapter.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| prometheus-adapter.prometheus.url | string | `"http://metrics-kube-prometheus-st-prometheus"` |  |
| prometheus-adapter.rules.default | bool | `false` |  |
| prometheus-adapter.rules.resource.cpu.containerLabel | string | `"container"` |  |
| prometheus-adapter.rules.resource.cpu.containerQuery | string | `"sum(irate(container_cpu_usage_seconds_total{<<.LabelMatchers>>,container!=\"POD\",container!=\"\",pod!=\"\"}[3m])) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.cpu.nodeQuery | string | `"sum(1 - irate(node_cpu_seconds_total{mode=\"idle\"}[3m]) * on(namespace, pod) group_left(node) node_namespace_pod:kube_pod_info:{<<.LabelMatchers>>}) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.cpu.resources.overrides.namespace.resource | string | `"namespace"` |  |
| prometheus-adapter.rules.resource.cpu.resources.overrides.node.resource | string | `"node"` |  |
| prometheus-adapter.rules.resource.cpu.resources.overrides.pod.resource | string | `"pod"` |  |
| prometheus-adapter.rules.resource.memory.containerLabel | string | `"container"` |  |
| prometheus-adapter.rules.resource.memory.containerQuery | string | `"sum(container_memory_working_set_bytes{<<.LabelMatchers>>,container!=\"POD\",container!=\"\",pod!=\"\"}) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.memory.nodeQuery | string | `"sum(node_memory_MemTotal_bytes{job=\"node-exporter\",<<.LabelMatchers>>} - node_memory_MemAvailable_bytes{job=\"node-exporter\",<<.LabelMatchers>>}) by (<<.GroupBy>>)"` |  |
| prometheus-adapter.rules.resource.memory.resources.overrides.namespace.resource | string | `"namespace"` |  |
| prometheus-adapter.rules.resource.memory.resources.overrides.node.resource | string | `"node"` |  |
| prometheus-adapter.rules.resource.memory.resources.overrides.pod.resource | string | `"pod"` |  |
| prometheus-adapter.rules.resource.window | string | `"3m"` |  |
| prometheus-adapter.tolerations[0].effect | string | `"NoSchedule"` |  |
| prometheus-adapter.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |

# Dashboards

## Etcs
- https://grafana.com/grafana/dashboards/3070

## ElasticSearch
- https://grafana.com/grafana/dashboards/266

