kubezero-cert-manager
=====================
KubeZero Umbrella Chart for cert-manager

Current chart version is `0.3.3`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.jetstack.io | cert-manager | 0.15.0 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cert-manager.cainjector.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| cert-manager.cainjector.tolerations[0].effect | string | `"NoSchedule"` |  |
| cert-manager.cainjector.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cert-manager.extraArgs[0] | string | `"--dns01-recursive-nameservers-only"` |  |
| cert-manager.ingressShim.defaultIssuerKind | string | `"ClusterIssuer"` |  |
| cert-manager.ingressShim.defaultIssuerName | string | `"letsencrypt-dns-prod"` |  |
| cert-manager.installCRDs | bool | `true` |  |
| cert-manager.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| cert-manager.prometheus.servicemonitor.enabled | bool | `false` |  |
| cert-manager.tolerations[0].effect | string | `"NoSchedule"` |  |
| cert-manager.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cert-manager.webhook.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| cert-manager.webhook.tolerations[0].effect | string | `"NoSchedule"` |  |
| cert-manager.webhook.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| clusterIssuer | object | `{}` |  |
| localCA.enabled | bool | `true` |  |
| localCA.selfsigning | bool | `true` |  |
