# kubezero-redis

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Umbrella Chart for Redis HA

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | redis | 12.0.0 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| istio.enabled | bool | `false` |  |
| redis.cluster.slaveCount | int | `0` |  |
| redis.master.persistence.enabled | bool | `false` |  |
| redis.metrics.enabled | bool | `false` |  |
| redis.metrics.serviceMonitor.enabled | bool | `false` |  |
| redis.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
| redis.metrics.serviceMonitor.selector.release | string | `"metrics"` |  |
| redis.usePassword | bool | `false` |  |

# Dashboards

## Redis

# Resources
- https://github.com/helm/charts/tree/master/stable/redis
- https://github.com/rustudorcalin/deploying-redis-cluster
-
