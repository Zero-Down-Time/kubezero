kubezero
========
KubeZero Helm chart to install Zero Down Time Kuberenetes platform

Current chart version is `0.1.8`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 2.2.12 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.controller.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.installCRDs | bool | `false` |  |
| argo-cd.redis.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.redis.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.redis.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| argo-cd.repoServer.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.repoServer.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.repoServer.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| argo-cd.server.config.url | string | `"argocd.example.com"` |  |
| argo-cd.server.extraArgs[0] | string | `"--insecure"` |  |
| argo-cd.server.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.server.service.servicePortHttpsName | string | `"grpc"` |  |
| argo-cd.server.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.server.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| bootstrap | bool | `true` |  |
| istio.enabled | bool | `false` |  |
| istio.gateway | string | `"ingressgateway.istio-system.svc.cluster.local"` |  |
