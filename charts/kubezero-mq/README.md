# kubezero-mq

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for MQ systems like NATS

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
|  | nats | 0.8.3 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nats.enabled | bool | `false` |  |
| nats.exporter.serviceMonitor.enabled | bool | `false` |  |
| nats.nats.advertise | bool | `false` |  |
| nats.nats.image | string | `"nats:2.2.1-alpine3.13"` |  |
| nats.nats.jetstream.enabled | bool | `true` |  |
| nats.natsbox.enabled | bool | `false` |  |

## Resources

### NATS
- https://grafana.com/grafana/dashboards/13707
