# kubezero-network

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things network

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | stefan@zero-downtime.net |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
| https://metallb.github.io/metallb | metallb | 0.10.2 |

# MetalLB   
   
## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cilium.enabled | bool | `false` |  |
| metallb.configInline | object | `{}` |  |
| metallb.controller.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| metallb.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| metallb.enabled | bool | `false` |  |
| metallb.psp.create | bool | `false` |  |
| multus.enabled | bool | `false` |  |
