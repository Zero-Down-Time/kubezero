# uptime-kuma

![Version: 0.1.10](https://img.shields.io/badge/Version-0.1.10-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.9.1](https://img.shields.io/badge/AppVersion-1.9.1-informational?style=flat-square)

Chart for deploying uptime-kuma

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | override the full name of the uptime-kuma chart |
| image | string | `"louislam/uptime-kuma"` |  |
| istio.enabled | bool | `false` |  |
| istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| istio.url | string | `"uptime.example.com"` |  |
| nameOverride | string | `""` | override the name of the uptime-kuma chart |
| service.port | int | `3001` | The port to be used by the uptime-kuma service |
| serviceMonitor.enabled | bool | `false` |  |

## Resources

- https://github.com/louislam/uptime-kuma

