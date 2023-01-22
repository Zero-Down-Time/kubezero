# kubezero-istio-gateway

![Version: 0.9.0](https://img.shields.io/badge/Version-0.9.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Umbrella Chart for Istio gateways

Installs Istio Ingress Gateways, requires kubezero-istio to be installed !

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.24.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.5 |
| https://istio-release.storage.googleapis.com/charts | gateway | 1.16.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certificates | list | `[]` |  |
| gateway.autoscaling.enabled | bool | `false` |  |
| gateway.autoscaling.maxReplicas | int | `4` |  |
| gateway.autoscaling.minReplicas | int | `1` |  |
| gateway.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| gateway.podAnnotations."proxy.istio.io/config" | string | `"{ \"terminationDrainDuration\": \"20s\" }"` |  |
| gateway.replicaCount | int | `1` |  |
| gateway.resources.limits.memory | string | `"512Mi"` |  |
| gateway.resources.requests.cpu | string | `"50m"` |  |
| gateway.resources.requests.memory | string | `"64Mi"` |  |
| gateway.service.externalTrafficPolicy | string | `"Local"` |  |
| gateway.service.type | string | `"NodePort"` |  |
| proxyProtocol | bool | `true` |  |
| telemetry.enabled | bool | `false` |  |

## Resources

- https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#IstioOperatorSpec
- https://github.com/istio/istio/blob/master/manifests/profiles/default.yaml
- https://istio.io/latest/docs/setup/install/standalone-operator/
