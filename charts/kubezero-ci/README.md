# kubezero-ci

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| https://dl.gitea.io/charts/ | gitea | 4.1.1 |
| https://gocd.github.io/helm-chart | gocd | 1.39.4 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.4 |

# Jenkins
   
# goCD
   
## Resources   

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gitea.enabled | bool | `false` |  |
| gitea.gitea.admin.existingSecret | string | `"gitea-admin-secret"` |  |
| gitea.gitea.cache.builtIn.enabled | bool | `false` |  |
| gitea.gitea.config.cache.ADAPTER | string | `"memory"` |  |
| gitea.gitea.config.database.DB_TYPE | string | `"sqlite3"` |  |
| gitea.gitea.database.builtIn.mariadb.enabled | bool | `false` |  |
| gitea.gitea.database.builtIn.mysql.enabled | bool | `false` |  |
| gitea.gitea.database.builtIn.postgresql.enabled | bool | `false` |  |
| gitea.gitea.demo | bool | `false` |  |
| gitea.gitea.metrics.enabled | bool | `false` |  |
| gitea.gitea.metrics.serviceMonitor.enabled | bool | `false` |  |
| gitea.image.rootless | bool | `true` |  |
| gitea.istio.enabled | bool | `false` |  |
| gitea.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| gitea.istio.url | string | `""` |  |
| gitea.persistence.enabled | bool | `true` |  |
| gitea.persistence.size | string | `"4Gi"` |  |
| gitea.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| gitea.securityContext.capabilities.add[0] | string | `"SYS_CHROOT"` |  |
| gitea.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| gocd.enabled | bool | `false` |  |
| gocd.istio.enabled | bool | `false` |  |
| gocd.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| gocd.istio.url | string | `""` |  |
| gocd.server.ingress.enabled | bool | `false` |  |
| gocd.server.service.type | string | `"ClusterIP"` |  |
| jenkins.enabled | bool | `false` |  |
