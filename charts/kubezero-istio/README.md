# kubezero-istio

![Version: 0.4.1](https://img.shields.io/badge/Version-0.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.8.1](https://img.shields.io/badge/AppVersion-1.8.1-informational?style=flat-square)

KubeZero Umbrella Chart for Istio

Installs the Istio control plane

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
|  | base | 1.1.0 |
|  | istio-discovery | 1.2.0 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.defaultPodDisruptionBudget.enabled | bool | `false` |  |
| global.hub | string | `"docker.io/istio"` |  |
| global.jwtPolicy | string | `"first-party-jwt"` |  |
| global.logAsJson | bool | `true` |  |
| global.priorityClassName | string | `"system-cluster-critical"` |  |
| global.tag | string | `"1.8.0"` |  |
| istio-discovery.meshConfig.accessLogEncoding | string | `"JSON"` |  |
| istio-discovery.meshConfig.accessLogFile | string | `"/dev/stdout"` |  |
| istio-discovery.meshConfig.h2UpgradePolicy | string | `"DO_NOT_UPGRADE"` |  |
| istio-discovery.meshConfig.tcpKeepalive.interval | string | `"30s"` |  |
| istio-discovery.meshConfig.tcpKeepalive.time | string | `"60s"` |  |
| istio-discovery.pilot.autoscaleEnabled | bool | `false` |  |
| istio-discovery.pilot.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| istio-discovery.pilot.replicaCount | int | `1` |  |
| istio-discovery.pilot.resources.requests.cpu | string | `"100m"` |  |
| istio-discovery.pilot.resources.requests.memory | string | `"128Mi"` |  |
| istio-discovery.pilot.tolerations[0].effect | string | `"NoSchedule"` |  |
| istio-discovery.pilot.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| istio-discovery.telemetry.enabled | bool | `false` |  |

## Resources

- https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#IstioOperatorSpec
- https://github.com/istio/istio/blob/master/manifests/profiles/default.yaml
- https://istio.io/latest/docs/setup/install/standalone-operator/
