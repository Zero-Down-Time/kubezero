# kubezero-istio

![Version: 0.7.3](https://img.shields.io/badge/Version-0.7.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.11.1](https://img.shields.io/badge/AppVersion-1.11.1-informational?style=flat-square)

KubeZero Umbrella Chart for Istio

Installs the Istio control plane

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
|  | base | 1.11.1 |
|  | istio-discovery | 1.11.1 |
|  | kiali-server | 1.38.1 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.defaultPodDisruptionBudget.enabled | bool | `false` |  |
| global.logAsJson | bool | `true` |  |
| global.priorityClassName | string | `"system-cluster-critical"` |  |
| istio-discovery.meshConfig.accessLogEncoding | string | `"JSON"` |  |
| istio-discovery.meshConfig.accessLogFile | string | `"/dev/stdout"` |  |
| istio-discovery.meshConfig.tcpKeepalive.interval | string | `"60s"` |  |
| istio-discovery.meshConfig.tcpKeepalive.time | string | `"120s"` |  |
| istio-discovery.pilot.autoscaleEnabled | bool | `false` |  |
| istio-discovery.pilot.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| istio-discovery.pilot.replicaCount | int | `1` |  |
| istio-discovery.pilot.resources.requests.cpu | string | `"100m"` |  |
| istio-discovery.pilot.resources.requests.memory | string | `"128Mi"` |  |
| istio-discovery.pilot.tolerations[0].effect | string | `"NoSchedule"` |  |
| istio-discovery.pilot.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| istio-discovery.telemetry.enabled | bool | `false` |  |
| kiali-server.auth.strategy | string | `"anonymous"` |  |
| kiali-server.deployment.ingress_enabled | bool | `false` |  |
| kiali-server.deployment.view_only_mode | bool | `true` |  |
| kiali-server.enabled | bool | `false` |  |
| kiali-server.external_services.custom_dashboards.enabled | bool | `false` |  |
| kiali-server.external_services.prometheus.url | string | `"http://metrics-kube-prometheus-st-prometheus.monitoring:9090"` |  |
| kiali-server.istio.enabled | bool | `false` |  |
| kiali-server.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| kiali-server.server.metrics_enabled | bool | `false` |  |
| rateLimiting.descriptors.ingress[0].key | string | `"remote_address"` |  |
| rateLimiting.descriptors.ingress[0].rate_limit.requests_per_unit | int | `10` |  |
| rateLimiting.descriptors.ingress[0].rate_limit.unit | string | `"second"` |  |
| rateLimiting.descriptors.privateIngress[0].key | string | `"remote_address"` |  |
| rateLimiting.descriptors.privateIngress[0].rate_limit.requests_per_unit | int | `10` |  |
| rateLimiting.descriptors.privateIngress[0].rate_limit.unit | string | `"second"` |  |
| rateLimiting.enabled | bool | `false` |  |
| rateLimiting.failureModeDeny | bool | `false` |  |
| rateLimiting.localCacheSize | int | `1048576` |  |
| rateLimiting.log.format | string | `"json"` |  |
| rateLimiting.log.level | string | `"warn"` |  |

## Resources

- https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#IstioOperatorSpec
- https://github.com/istio/istio/blob/master/manifests/profiles/default.yaml
- https://istio.io/latest/docs/setup/install/standalone-operator/

### Grafana
- https://grafana.com/grafana/dashboards/7645
- https://grafana.com/grafana/dashboards/7639
- https://grafana.com/grafana/dashboards/7636
- https://grafana.com/grafana/dashboards/7630
