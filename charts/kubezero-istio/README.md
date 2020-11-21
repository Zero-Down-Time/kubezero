# kubezero-istio

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.7.4](https://img.shields.io/badge/AppVersion-1.7.4-informational?style=flat-square)

KubeZero Umbrella Chart for Istio

Installs Istio Operator and KubeZero Istio profile

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
|  | istio-operator | >= 1.7 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## KubeZero default configuration
- mapped istio-operator to run on the controller nodes only

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.autoscaleEnabled | bool | `false` |  |
| ingress.dnsNames[0] | string | `"*"` |  |
| ingress.private.enabled | bool | `true` |  |
| ingress.private.nodeSelector | string | `"31080_31443_31671_31672_31224"` |  |
| ingress.public.enabled | bool | `true` |  |
| ingress.replicaCount | int | `2` |  |
| ingress.type | string | `"NodePort"` |  |
| istio-operator.hub | string | `"docker.io/istio"` |  |
| istio-operator.tag | string | `"1.7.4"` |  |
| istiod.autoscaleEnabled | bool | `false` |  |
| istiod.replicaCount | int | `1` |  |

## Resources

- https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#IstioOperatorSpec
- https://github.com/istio/istio/blob/master/manifests/profiles/default.yaml
- https://istio.io/latest/docs/setup/install/standalone-operator/
