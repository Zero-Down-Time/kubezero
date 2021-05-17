# kubezero-sql

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for SQL databases like MariaDB, PostgreSQL

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.18.0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb-galera | 5.8.0 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| mariadb-galera.configurationConfigMap | string | `"{{ .Release.Name }}-mariadb-galera-configuration"` |  |
| mariadb-galera.db.password | string | `"12345qwert"` |  |
| mariadb-galera.db.user | string | `"mariadb"` |  |
| mariadb-galera.enabled | bool | `true` |  |
| mariadb-galera.galera.mariabackup.password | string | `"12345qwert"` |  |
| mariadb-galera.istio.enabled | bool | `false` |  |
| mariadb-galera.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| mariadb-galera.istio.url | string | `"mariadb.example.com"` |  |
| mariadb-galera.metrics.enabled | bool | `false` |  |
| mariadb-galera.metrics.prometheusRules.enabled | bool | `false` |  |
| mariadb-galera.metrics.serviceMonitor.enabled | bool | `false` |  |
| mariadb-galera.replicaCount | int | `2` |  |
| mariadb-galera.rootUser.password | string | `"12345qwert"` |  |

# Changes

## MariaDB
- custom my.cnf, source: https://github.com/bitnami/charts/blob/70d602fea38010145c20e1ca59be06e4cf32bf80/bitnami/mariadb-galera/values.yaml#L261

## Resources

### MariaDB
