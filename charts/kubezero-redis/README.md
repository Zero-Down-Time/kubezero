# kubezero-redis

![Version: 0.3.5](https://img.shields.io/badge/Version-0.3.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Umbrella Chart for Redis HA

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.3 |
| https://charts.bitnami.com/bitnami | redis | 15.5.4 |
| https://charts.bitnami.com/bitnami | redis-cluster | 6.3.9 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| istio.enabled | bool | `false` |  |
| redis-cluster.cluster.nodes | int | `2` |  |
| redis-cluster.cluster.replicas | int | `1` |  |
| redis-cluster.enabled | bool | `false` |  |
| redis-cluster.metrics.enabled | bool | `false` |  |
| redis-cluster.metrics.serviceMonitor.enabled | bool | `false` |  |
| redis-cluster.persistence.enabled | bool | `false` |  |
| redis-cluster.usePassword | bool | `false` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.auth.enabled | bool | `false` |  |
| redis.enabled | bool | `false` |  |
| redis.master.persistence.enabled | bool | `false` |  |
| redis.metrics.enabled | bool | `false` |  |
| redis.metrics.serviceMonitor.enabled | bool | `false` |  |
| redis.replica.replicaCount | int | `0` |  |
| snapshotgroups | object | `{}` |  |

# Dashboards
https://grafana.com/grafana/dashboards/11835

## Redis

# Resources
- https://ot-container-kit.github.io/redis-operator/
- https://github.com/helm/charts/tree/master/stable/redis
- https://github.com/rustudorcalin/deploying-redis-cluster
-
