# kubezero-ci

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things CI

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
| https://gocd.github.io/helm-chart | gocd | 1.39.4 |

# Jenkins
   
# goCD
   
## Resources   

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fuseDevicePlugin.enabled | bool | `false` |  |
| k8sEcrLoginRenew.enabled | bool | `false` |  |
| metallb.configInline | object | `{}` |  |
| metallb.controller.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| metallb.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| metallb.enabled | bool | `false` |  |
| metallb.psp.create | bool | `false` |  |
