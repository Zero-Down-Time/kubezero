# kubezero-argo-cd

![Version: 0.6.0](https://img.shields.io/badge/Version-0.6.0-informational?style=flat-square)

KubeZero ArgoCD Helm chart to install ArgoCD itself and the KubeZero ArgoCD Application

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.17.0`

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 2.9.3 |
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.controller.args.appResyncPeriod | string | `"300"` |  |
| argo-cd.controller.args.operationProcessors | string | `"4"` |  |
| argo-cd.controller.args.statusProcessors | string | `"8"` |  |
| argo-cd.controller.logFormat | string | `"json"` |  |
| argo-cd.controller.metrics.enabled | bool | `false` |  |
| argo-cd.controller.metrics.serviceMonitor.additionalLabels.release | string | `"metrics"` |  |
| argo-cd.controller.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.controller.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
| argo-cd.controller.resources.requests.cpu | string | `"100m"` |  |
| argo-cd.controller.resources.requests.memory | string | `"256Mi"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.global.image.tag | string | `"v1.7.8"` |  |
| argo-cd.installCRDs | bool | `false` |  |
| argo-cd.istio.enabled | bool | `false` | Deploy Istio VirtualService to expose ArgoCD |
| argo-cd.istio.gateway | string | `"istio-system/ingressgateway"` | Name of the Istio gateway to add the VirtualService to |
| argo-cd.istio.ipBlocks | list | `[]` |  |
| argo-cd.repoServer.logFormat | string | `"json"` |  |
| argo-cd.repoServer.metrics.enabled | bool | `false` |  |
| argo-cd.repoServer.metrics.serviceMonitor.additionalLabels.release | string | `"metrics"` |  |
| argo-cd.repoServer.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.repoServer.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
| argo-cd.server.config."resource.customizations" | string | `"cert-manager.io/Certificate:\n  # Lua script for customizing the health status assessment\n  health.lua: |\n    hs = {}\n    if obj.status ~= nil then\n      if obj.status.conditions ~= nil then\n        for i, condition in ipairs(obj.status.conditions) do\n          if condition.type == \"Ready\" and condition.status == \"False\" then\n            hs.status = \"Degraded\"\n            hs.message = condition.message\n            return hs\n          end\n          if condition.type == \"Ready\" and condition.status == \"True\" then\n            hs.status = \"Healthy\"\n            hs.message = condition.message\n            return hs\n          end\n        end\n      end\n    end\n    hs.status = \"Progressing\"\n    hs.message = \"Waiting for certificate\"\n    return hs\n"` |  |
| argo-cd.server.config.url | string | `"argocd.example.com"` | ArgoCD hostname to be exposed via Istio |
| argo-cd.server.extraArgs[0] | string | `"--insecure"` |  |
| argo-cd.server.logFormat | string | `"json"` |  |
| argo-cd.server.metrics.enabled | bool | `false` |  |
| argo-cd.server.metrics.serviceMonitor.additionalLabels.release | string | `"metrics"` |  |
| argo-cd.server.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.metrics.serviceMonitor.namespace | string | `"monitoring"` |  |
| argo-cd.server.service.servicePortHttpsName | string | `"grpc"` |  |
| kubezero.global.defaultDestination | object | `{"server":"https://kubernetes.default.svc"}` | Destination cluster |
| kubezero.global.defaultSource.pathPrefix | string | `""` | optional path prefix within repoURL to support eg. remote subtrees |
| kubezero.global.defaultSource.repoURL | string | `"https://github.com/zero-down-time/kubezero"` | default repository for argocd applications |
| kubezero.global.defaultSource.targetRevision | string | `"HEAD"` | default tracking of repoURL |

## Resources
- https://argoproj.github.io/argo-cd/operator-manual/metrics/
- https://raw.githubusercontent.com/argoproj/argo-cd/master/examples/dashboard.json
