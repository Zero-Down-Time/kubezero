# kubezero-argo

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

KubeZero Argo - Events, Workflow, CD

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.26.0`

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-events | 2.4.3 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-events.configs.jetstream.settings.maxFileStore | int | `-1` | Maximum size of the file storage (e.g. 20G) |
| argo-events.configs.jetstream.settings.maxMemoryStore | int | `-1` | Maximum size of the memory storage (e.g. 1G) |
| argo-events.configs.jetstream.streamConfig.duplicates | string | `"300s"` | Not documented at the moment |
| argo-events.configs.jetstream.streamConfig.maxAge | string | `"72h"` | Maximum age of existing messages, i.e. “72h”, “4h35m” |
| argo-events.configs.jetstream.streamConfig.maxBytes | string | `"1GB"` |  |
| argo-events.configs.jetstream.streamConfig.maxMsgs | int | `1000000` | Maximum number of messages before expiring oldest message |
| argo-events.configs.jetstream.streamConfig.replicas | int | `1` | Number of replicas, defaults to 3 and requires minimal 3 |
| argo-events.configs.jetstream.versions[0].configReloaderImage | string | `"natsio/nats-server-config-reloader:0.14.1"` |  |
| argo-events.configs.jetstream.versions[0].metricsExporterImage | string | `"natsio/prometheus-nats-exporter:0.14.0"` |  |
| argo-events.configs.jetstream.versions[0].natsImage | string | `"nats:2.10.11-scratch"` |  |
| argo-events.configs.jetstream.versions[0].startCommand | string | `"/nats-server"` |  |
| argo-events.configs.jetstream.versions[0].version | string | `"2.10.11"` |  |
| argo-events.enabled | bool | `false` |  |

## Resources

