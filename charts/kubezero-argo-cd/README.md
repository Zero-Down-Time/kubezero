kubezero-argo-cd
================
KubeZero ArgoCD Helm chart to install ArgoCD itself and the KubeZero ArgoCD Application

Current chart version is `0.4.1`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 2.6.0 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.controller.args.appResyncPeriod | string | `"300"` |  |
| argo-cd.controller.args.operationProcessors | string | `"1"` |  |
| argo-cd.controller.args.statusProcessors | string | `"2"` |  |
| argo-cd.controller.metrics.enabled | bool | `false` |  |
| argo-cd.controller.metrics.serviceMonitor.additionalLabels.release | string | `"metrics"` |  |
| argo-cd.controller.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.controller.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
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
| argo-cd.repoServer.metrics.enabled | bool | `false` |  |
| argo-cd.repoServer.metrics.serviceMonitor.additionalLabels.release | string | `"metrics"` |  |
| argo-cd.repoServer.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.repoServer.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
| argo-cd.repoServer.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.repoServer.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.repoServer.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| argo-cd.server.config."resource.customizations" | string | `"cert-manager.io/Certificate:\n  # Lua script for customizing the health status assessment\n  health.lua: |\n    hs = {}\n    if obj.status ~= nil then\n      if obj.status.conditions ~= nil then\n        for i, condition in ipairs(obj.status.conditions) do\n          if condition.type == \"Ready\" and condition.status == \"False\" then\n            hs.status = \"Degraded\"\n            hs.message = condition.message\n            return hs\n          end\n          if condition.type == \"Ready\" and condition.status == \"True\" then\n            hs.status = \"Healthy\"\n            hs.message = condition.message\n            return hs\n          end\n        end\n      end\n    end\n    hs.status = \"Progressing\"\n    hs.message = \"Waiting for certificate\"\n    return hs\n"` |  |
| argo-cd.server.config.url | string | `"argocd.example.com"` | ArgoCD hostname to be exposed via Istio |
| argo-cd.server.extraArgs[0] | string | `"--insecure"` |  |
| argo-cd.server.metrics.enabled | bool | `false` |  |
| argo-cd.server.metrics.serviceMonitor.additionalLabels.release | string | `"metrics"` |  |
| argo-cd.server.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
| argo-cd.server.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| argo-cd.server.service.servicePortHttpsName | string | `"grpc"` |  |
| argo-cd.server.tolerations[0].effect | string | `"NoSchedule"` |  |
| argo-cd.server.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| kubezero.global.defaultDestination | object | `{"server":"https://kubernetes.default.svc"}` | Destination cluster |
| kubezero.global.defaultSource.pathPrefix | string | `""` | optional path prefix within repoURL to support eg. remote subtrees |
| kubezero.global.defaultSource.repoURL | string | `"https://github.com/zero-down-time/kubezero"` | default repository for argocd applications |
| kubezero.global.defaultSource.targetRevision | string | `"HEAD"` | default tracking of repoURL |

## Resources
- https://argoproj.github.io/argo-cd/operator-manual/metrics/
- https://raw.githubusercontent.com/argoproj/argo-cd/master/examples/dashboard.json
