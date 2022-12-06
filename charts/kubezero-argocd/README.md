# kubezero-argocd

![Version: 0.11.1](https://img.shields.io/badge/Version-0.11.1-informational?style=flat-square)

KubeZero ArgoCD integration, config and branding as well as ArgoCD image-updater

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.24.0`

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 5.16.1 |
| https://argoproj.github.io/argo-helm | argocd-apps | 0.0.4 |
| https://argoproj.github.io/argo-helm | argocd-image-updater | 0.8.1 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.5 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.applicationSet.enabled | bool | `false` |  |
| argo-cd.configs.cm."resource.customizations" | string | `"cert-manager.io/Certificate:\n  # Lua script for customizing the health status assessment\n  health.lua: |\n    hs = {}\n    if obj.status ~= nil then\n      if obj.status.conditions ~= nil then\n        for i, condition in ipairs(obj.status.conditions) do\n          if condition.type == \"Ready\" and condition.status == \"False\" then\n            hs.status = \"Degraded\"\n            hs.message = condition.message\n            return hs\n          end\n          if condition.type == \"Ready\" and condition.status == \"True\" then\n            hs.status = \"Healthy\"\n            hs.message = condition.message\n            return hs\n          end\n        end\n      end\n    end\n    hs.status = \"Progressing\"\n    hs.message = \"Waiting for certificate\"\n    return hs\n"` |  |
| argo-cd.configs.cm."timeout.reconciliation" | int | `300` |  |
| argo-cd.configs.cm."ui.bannercontent" | string | `"KubeZero v1.24 - Release notes"` |  |
| argo-cd.configs.cm."ui.bannerpermanent" | string | `"true"` |  |
| argo-cd.configs.cm."ui.bannerposition" | string | `"bottom"` |  |
| argo-cd.configs.cm."ui.bannerurl" | string | `"https://kubezero.com/releases/v1.24"` |  |
| argo-cd.configs.cm.url | string | `"argocd.example.com"` |  |
| argo-cd.configs.knownHosts.data.ssh_known_hosts | string | `"bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==\ngithub.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=\ngithub.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl\ngithub.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==\ngitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=\ngitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf\ngitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9\ngit.zero-downtime.net ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8YdJ4YcOK7A0K7qOWsRjCS+wHTStXRcwBe7gjG43HPSNijiCKoGf/c+tfNsRhyouawg7Law6M6ahmS/jKWBpznRIM+OdOFVSuhnK/nr6h6wG3/ZfdLicyAPvx1/STGY/Fc6/zXA88i/9PV+g84gSVmhf3fGY92wokiASiu9DU4T9dT1gIkdyOX6fbMi1/mMKLSrHnAQcjyasYDvw9ISCJ95EoSwbj7O4c+7jo9fxYvdCfZZZAEZGozTRLAAO0AnjVcRah7bZV/jfHJuhOipV/TB7UVAhlVv1dfGV7hoTp9UKtKZFJF4cjIrSGxqQA/mdhSdLgkepK7yc4Jp2xGnaarhY29DfqsQqop+ugFpTbj7Xy5Rco07mXc6XssbAZhI1xtCOX20N4PufBuYippCK5AE6AiAyVtJmvfGQk4HP+TjOyhFo7PZm3wc9Hym7IBBVC0Sl30K8ddufkAgHwNGvvu1ZmD9ZWaMOXJDHBCZGMMr16QREZwVtZTwMEQalc7/yqmuqMhmcJIfs/GA2Lt91y+pq9C8XyeUL0VFPch0vkcLSRe3ghMZpRFJ/ht307xPcLzgTJqN6oQtNNDzSQglSEjwhge2K4GyWcIh+oGsWxWz5dHyk1iJmw90Y976BZIl/mYVgbTtZAJ81oGe/0k5rAe+LDL+Yq6tG28QFOg0QmiQ==\n"` |  |
| argo-cd.configs.metrics.enabled | bool | `false` |  |
| argo-cd.configs.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.configs.params."controller.operation.processors" | string | `"5"` |  |
| argo-cd.configs.params."controller.status.processors" | string | `"10"` |  |
| argo-cd.configs.params."server.enable.gzip" | bool | `true` |  |
| argo-cd.configs.params."server.insecure" | bool | `true` |  |
| argo-cd.configs.resources.requests.cpu | string | `"100m"` |  |
| argo-cd.configs.resources.requests.memory | string | `"256Mi"` |  |
| argo-cd.configs.secret.createSecret | bool | `false` |  |
| argo-cd.configs.styles | string | `".sidebar__logo img { content: url(https://cdn.zero-downtime.net/assets/kubezero/logo-small-64.png); }\n.sidebar { background: linear-gradient(to bottom, #6A4D79, #493558, #2D1B30, #0D0711); }\n"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.global.logging.format | string | `"json"` |  |
| argo-cd.notifications.enabled | bool | `false` |  |
| argo-cd.repoServer.metrics.enabled | bool | `false` |  |
| argo-cd.repoServer.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.metrics.enabled | bool | `false` |  |
| argo-cd.server.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.service.servicePortHttpsName | string | `"grpc"` |  |
| argocd-apps.applications | list | `[]` |  |
| argocd-apps.projects | list | `[]` |  |
| argocd-image-updater.enabled | bool | `false` |  |
| istio.enabled | bool | `false` | Deploy Istio VirtualService to expose ArgoCD |
| istio.gateway | string | `"istio-ingress/ingressgateway"` | Name of the Istio gateway to add the VirtualService to |
| istio.ipBlocks | list | `[]` |  |

## Resources
- https://argoproj.github.io/argo-cd/operator-manual/metrics/
- https://raw.githubusercontent.com/argoproj/argo-cd/master/examples/dashboard.json
