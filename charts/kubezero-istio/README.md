# kubezero-istio

![Version: 0.8.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Umbrella Chart for Istio

Installs the Istio control plane

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
|  | kiali-server | 1.38.1 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.4 |
| https://istio-release.storage.googleapis.com/charts | base | 1.13.3 |
| https://istio-release.storage.googleapis.com/charts | istiod | 1.13.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.defaultPodDisruptionBudget.enabled | bool | `false` |  |
| global.logAsJson | bool | `true` |  |
| global.priorityClassName | string | `"system-cluster-critical"` |  |
| global.tag | string | `"1.13.3-distroless"` |  |
| istiod.meshConfig.accessLogEncoding | string | `"JSON"` |  |
| istiod.meshConfig.accessLogFile | string | `"/dev/stdout"` |  |
| istiod.meshConfig.tcpKeepalive.interval | string | `"60s"` |  |
| istiod.meshConfig.tcpKeepalive.time | string | `"120s"` |  |
| istiod.pilot.autoscaleEnabled | bool | `false` |  |
| istiod.pilot.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| istiod.pilot.replicaCount | int | `1` |  |
| istiod.pilot.resources.requests.cpu | string | `"100m"` |  |
| istiod.pilot.resources.requests.memory | string | `"128Mi"` |  |
| istiod.pilot.tolerations[0].effect | string | `"NoSchedule"` |  |
| istiod.pilot.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| istiod.telemetry.enabled | bool | `false` |  |
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
