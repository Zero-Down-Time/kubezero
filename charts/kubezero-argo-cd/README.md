kubezero-argo-cd
================
KubeZero ArgoCD Helm chart to install ArgoCD itself and the KubeZero ArgoCD Application

Current chart version is `0.3.9`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 2.6.0 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.controller.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.installCRDs | bool | `false` |  |
| argo-cd.istio.enabled | bool | `false` | Deploy Istio VirtualService to expose ArgoCD |
| argo-cd.istio.gateway | string | `"istio-system/ingressgateway"` | Name of the Istio gateway to add the VirtualService to |
| argo-cd.istio.ipBlocks | list | `[]` |  |
| argo-cd.redis.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.redis.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.redis.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| argo-cd.repoServer.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.repoServer.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.repoServer.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| argo-cd.server.config.url | string | `"argocd.example.com"` | ArgoCD hostname to be exposed via Istio |
| argo-cd.server.extraArgs[0] | string | `"--insecure"` |  |
| argo-cd.server.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.server.service.servicePortHttpsName | string | `"grpc"` |  |
| argo-cd.server.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.server.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| kubezero.global.defaultDestination | object | `{"server":"https://kubernetes.default.svc"}` | Destination cluster |
| kubezero.global.defaultSource.pathPrefix | string | `""` | optional path prefix within repoURL to support eg. remote subtrees |
| kubezero.global.defaultSource.repoURL | string | `"https://github.com/zero-down-time/kubezero"` | default repository for argocd applications |
| kubezero.global.defaultSource.targetRevision | string | `"HEAD"` | default tracking of repoURL |
