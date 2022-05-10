# kubezero-mq

![Version: 0.2.3](https://img.shields.io/badge/Version-0.2.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for MQ systems like NATS, RabbitMQ

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
|  | nats | 0.8.4 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.3 |
| https://charts.bitnami.com/bitnami | rabbitmq | 9.0.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nats.enabled | bool | `false` |  |
| nats.exporter.serviceMonitor.enabled | bool | `false` |  |
| nats.istio.enabled | bool | `false` |  |
| nats.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| nats.mqtt.enabled | bool | `false` |  |
| nats.nats.advertise | bool | `false` |  |
| nats.nats.jetstream.enabled | bool | `true` |  |
| nats.natsbox.enabled | bool | `false` |  |
| rabbitmq.auth.erlangCookie | string | `"randomlongerlangcookie"` |  |
| rabbitmq.auth.password | string | `"supersecret"` |  |
| rabbitmq.auth.tls.enabled | bool | `false` |  |
| rabbitmq.auth.tls.existingSecret | string | `"rabbitmq-server-certificate"` |  |
| rabbitmq.auth.tls.existingSecretFullChain | bool | `true` |  |
| rabbitmq.auth.tls.failIfNoPeerCert | bool | `false` |  |
| rabbitmq.clustering.forceBoot | bool | `true` |  |
| rabbitmq.enabled | bool | `false` |  |
| rabbitmq.hosts | list | `[]` | hostnames of rabbitmq services, used for Istio and TLS |
| rabbitmq.istio.enabled | bool | `false` |  |
| rabbitmq.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| rabbitmq.metrics.enabled | bool | `false` |  |
| rabbitmq.metrics.serviceMonitor.enabled | bool | `false` |  |
| rabbitmq.pdb.create | bool | `true` |  |
| rabbitmq.podAntiAffinityPreset | string | `""` |  |
| rabbitmq.replicaCount | int | `1` |  |
| rabbitmq.resources.requests.cpu | string | `"100m"` |  |
| rabbitmq.resources.requests.memory | string | `"256Mi"` |  |
| rabbitmq.topologySpreadConstraints | string | `"- maxSkew: 1\n  topologyKey: topology.kubernetes.io/zone\n  whenUnsatisfiable: DoNotSchedule\n  labelSelector:\n    matchLabels: {{- include \"common.labels.matchLabels\" . | nindent 6 }}\n- maxSkew: 1\n  topologyKey: kubernetes.io/hostname\n  whenUnsatisfiable: DoNotSchedule\n  labelSelector:\n    matchLabels: {{- include \"common.labels.matchLabels\" . | nindent 6 }}"` |  |
| rabbitmq.ulimitNofiles | string | `""` |  |

## Resources

### NATS
- https://grafana.com/grafana/dashboards/13707
