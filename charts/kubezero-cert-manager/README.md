# kubezero-cert-manager

![Version: 0.9.1](https://img.shields.io/badge/Version-0.9.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero Umbrella Chart for cert-manager

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
| https://charts.jetstack.io | cert-manager | 1.8.0 |

## AWS - OIDC IAM roles

## Resolver Secrets
If your resolvers need additional sercrets like CloudFlare API tokens etc. make sure to provide these secrets separatly matching your defined issuers.

## Resources
- [Backup & Restore](https://cert-manager.io/docs/tutorials/backup/)
## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cert-manager.cainjector.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cert-manager.cainjector.tolerations[0].effect | string | `"NoSchedule"` |  |
| cert-manager.cainjector.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cert-manager.enabled | bool | `true` |  |
| cert-manager.extraArgs[0] | string | `"--dns01-recursive-nameservers-only"` |  |
| cert-manager.global.leaderElection.namespace | string | `"cert-manager"` |  |
| cert-manager.ingressShim.defaultIssuerKind | string | `"ClusterIssuer"` |  |
| cert-manager.ingressShim.defaultIssuerName | string | `"letsencrypt-dns-prod"` |  |
| cert-manager.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cert-manager.prometheus.servicemonitor.enabled | bool | `false` |  |
| cert-manager.startupapicheck.enabled | bool | `false` |  |
| cert-manager.tolerations[0].effect | string | `"NoSchedule"` |  |
| cert-manager.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cert-manager.webhook.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cert-manager.webhook.tolerations[0].effect | string | `"NoSchedule"` |  |
| cert-manager.webhook.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| clusterIssuer | object | `{}` |  |
| localCA.enabled | bool | `false` |  |
| localCA.selfsigning | bool | `true` |  |
