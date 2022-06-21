# kubezero-auth

![Version: 0.2.2](https://img.shields.io/badge/Version-0.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 18.0.1](https://img.shields.io/badge/AppVersion-18.0.1-informational?style=flat-square)

KubeZero umbrella chart for all things Authentication and Identity management

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.4 |
| https://charts.bitnami.com/bitnami | postgresql | 11.6.7 |

# Keycloak
   
## Operator

https://github.com/keycloak/keycloak/tree/main/operator

## Resources

- Codecentric Helm chart: `https://github.com/codecentric/helm-charts/tree/master/charts/keycloak`
- custom image: `https://www.keycloak.org/server/containers`
   
## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| keycloak.enabled | bool | `false` |  |
| keycloak.istio.enabled | bool | `false` |  |
| keycloak.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| keycloak.istio.url | string | `""` |  |
| keycloak.metrics.enabled | bool | `false` |  |
| postgresql.auth.database | string | `"keycloak"` |  |
| postgresql.auth.username | string | `"keycloak"` |  |
| postgresql.enabled | bool | `false` |  |
| postgresql.primary.persistence.size | string | `"1Gi"` |  |
| postgresql.readReplicas.replicaCount | int | `0` |  |
