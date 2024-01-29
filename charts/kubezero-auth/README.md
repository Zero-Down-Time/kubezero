# kubezero-auth

![Version: 0.4.5](https://img.shields.io/badge/Version-0.4.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 22.0.5](https://img.shields.io/badge/AppVersion-22.0.5-informational?style=flat-square)

KubeZero umbrella chart for all things Authentication and Identity management

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.26.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |
| oci://registry-1.docker.io/bitnamicharts | keycloak | 18.3.2 |

# Keycloak
   
## Operator

https://www.keycloak.org/operator/installation
https://github.com/keycloak/keycloak/tree/main/operator
https://github.com/aerogear/keycloak-metrics-spi
https://github.com/keycloak/keycloak-benchmark/tree/main/provision/minikube/keycloak/templates

## Resources
- https://github.com/bitnami/charts/tree/main/bitnami/keycloak
   
## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| keycloak.auth.adminUser | string | `"admin"` |  |
| keycloak.auth.existingSecret | string | `"kubezero-auth"` |  |
| keycloak.auth.passwordSecretKey | string | `"admin-password"` |  |
| keycloak.enabled | bool | `false` |  |
| keycloak.istio.admin.enabled | bool | `false` |  |
| keycloak.istio.admin.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| keycloak.istio.admin.url | string | `""` |  |
| keycloak.istio.auth.enabled | bool | `false` |  |
| keycloak.istio.auth.gateway | string | `"istio-ingress/ingressgateway"` |  |
| keycloak.istio.auth.url | string | `""` |  |
| keycloak.metrics.enabled | bool | `false` |  |
| keycloak.metrics.serviceMonitor.enabled | bool | `true` |  |
| keycloak.pdb.create | bool | `false` |  |
| keycloak.pdb.minAvailable | int | `1` |  |
| keycloak.postgresql.auth.database | string | `"keycloak"` |  |
| keycloak.postgresql.auth.existingSecret | string | `"kubezero-auth"` |  |
| keycloak.postgresql.auth.username | string | `"keycloak"` |  |
| keycloak.postgresql.primary.persistence.size | string | `"1Gi"` |  |
| keycloak.postgresql.readReplicas.replicaCount | int | `0` |  |
| keycloak.production | bool | `true` |  |
| keycloak.proxy | string | `"edge"` |  |
| keycloak.replicaCount | int | `1` |  |
| keycloak.resources.requests.cpu | string | `"100m"` |  |
| keycloak.resources.requests.memory | string | `"512Mi"` |  |
