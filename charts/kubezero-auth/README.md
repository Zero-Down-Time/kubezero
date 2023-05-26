# kubezero-auth

![Version: 0.3.5](https://img.shields.io/badge/Version-0.3.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 21.1.1](https://img.shields.io/badge/AppVersion-21.1.1-informational?style=flat-square)

KubeZero umbrella chart for all things Authentication and Identity management

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.25.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |
| https://charts.bitnami.com/bitnami | postgresql | 11.8.1 |

# Keycloak
   
## Operator

https://github.com/keycloak/keycloak/tree/main/operator
https://github.com/aerogear/keycloak-metrics-spi
https://github.com/keycloak/keycloak-benchmark/tree/main/provision/minikube/keycloak/templates

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
| keycloak.podDisruptionBudget.minAvailable | int | `1` |  |
| keycloak.replicas | int | `1` |  |
| postgresql.auth.database | string | `"keycloak"` |  |
| postgresql.auth.existingSecret | string | `"kubezero-auth-postgresql"` |  |
| postgresql.auth.username | string | `"keycloak"` |  |
| postgresql.enabled | bool | `false` |  |
| postgresql.primary.persistence.size | string | `"1Gi"` |  |
| postgresql.readReplicas.replicaCount | int | `0` |  |
