# kubezero-network

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things network

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
|  | calico | 0.2.2 |
| https://helm.cilium.io/ | cilium | 1.11.3 |
| https://metallb.github.io/metallb | metallb | 0.10.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| calico.enabled | bool | `false` |  |
| cilium.cni.exclusive | bool | `true` |  |
| cilium.enabled | bool | `false` |  |
| cilium.hubble.enabled | bool | `false` |  |
| cilium.operator.replicas | int | `1` |  |
| cilium.prometheus.enabled | bool | `false` |  |
| cilium.prometheus.port | int | `9091` |  |
| cilium.tunnel | string | `"geneve"` |  |
| metallb.configInline | object | `{}` |  |
| metallb.controller.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| metallb.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| metallb.enabled | bool | `false` |  |
| metallb.psp.create | bool | `false` |  |
| multus.enabled | bool | `false` |  |
| multus.tag | string | `"v3.8.1"` |  |
