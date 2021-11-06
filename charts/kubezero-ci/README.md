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
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.4 |

# Jenkins
   
# goCD
   
## Resources   

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gocd.enabled | bool | `false` |  |
| gocd.istio.enabled | bool | `false` |  |
| gocd.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| gocd.istio.url | string | `""` |  |
| gocd.server.ingress.enabled | bool | `false` |  |
| gocd.server.service.type | string | `"ClusterIP"` |  |
| jenkins.enabled | bool | `false` |  |
