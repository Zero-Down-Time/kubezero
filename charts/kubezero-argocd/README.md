# kubezero-argocd

![Version: 0.9.1](https://img.shields.io/badge/Version-0.9.1-informational?style=flat-square)

KubeZero ArgoCD Helm chart to install ArgoCD itself and the KubeZero ArgoCD Application

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | stefan@zero-downtime.net |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 3.29.5 |
| https://argoproj.github.io/argo-helm | argocd-applicationset | 1.4.0 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.configs.knownHosts.data.ssh_known_hosts | string | `"bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==\ngithub.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=\ngithub.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl\ngithub.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==\ngitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=\ngitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf\ngitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9\n[git.zero-downtime.net]:22000 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6C8EjqbFGTU/HJhwed7CSVd5o4cusQk++GnQb4gZ9RGySsm/Gfi2VtcphMQcwzQYfjwlQAcMFikQYTD0XjEqmxQ17Q0+XRdLr6svWMXLuvqkWIvke+b1AAnJhNj9dZl7jSZcLgZedUEAMIMEd7dQC+ggrBF0dzMxf+PmMwtPtpkeZ53+JyHoswtolV4qrGJy7xgQZjyABtwe0Cy/J8gVonvzPYhyl2Eh5z4KXY7MumtBSCv79G4PHNaBI7d59GmnNQCcZaxHykHEDPPr+ymZlhSoe+OBkbr5m7zCRMHWuQuz4mR/4wd1kvVReRTLr8ZJQc0cyNHHVJGj05QkAeBBv\n[git.zero-downtime.net]:22000 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBytYYdGzh0Y9iwx4hxgjiEwbxLxBdIaMbfpkB6zqiDqmMtVDprjZfRlDTew25+p+Hki7/xJPQRYqB6RR0fuTwo=\n[git.zero-downtime.net]:22000 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHv6s7N5aiiP9yt2y5EpGZxENxUtUdbWyWJsAgjHBCZZ\n"` |  |
| argo-cd.configs.secret.createSecret | bool | `false` |  |
| argo-cd.controller.args.appResyncPeriod | string | `"300"` |  |
| argo-cd.controller.args.operationProcessors | string | `"4"` |  |
| argo-cd.controller.args.statusProcessors | string | `"8"` |  |
| argo-cd.controller.logFormat | string | `"json"` |  |
| argo-cd.controller.metrics.enabled | bool | `false` |  |
| argo-cd.controller.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.controller.resources.requests.cpu | string | `"100m"` |  |
| argo-cd.controller.resources.requests.memory | string | `"256Mi"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.global | string | `nil` |  |
| argo-cd.installCRDs | bool | `false` |  |
| argo-cd.repoServer.logFormat | string | `"json"` |  |
| argo-cd.repoServer.metrics.enabled | bool | `false` |  |
| argo-cd.repoServer.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.config."resource.customizations" | string | `"cert-manager.io/Certificate:\n  # Lua script for customizing the health status assessment\n  health.lua: |\n    hs = {}\n    if obj.status ~= nil then\n      if obj.status.conditions ~= nil then\n        for i, condition in ipairs(obj.status.conditions) do\n          if condition.type == \"Ready\" and condition.status == \"False\" then\n            hs.status = \"Degraded\"\n            hs.message = condition.message\n            return hs\n          end\n          if condition.type == \"Ready\" and condition.status == \"True\" then\n            hs.status = \"Healthy\"\n            hs.message = condition.message\n            return hs\n          end\n        end\n      end\n    end\n    hs.status = \"Progressing\"\n    hs.message = \"Waiting for certificate\"\n    return hs\n"` |  |
| argo-cd.server.config.url | string | `"argocd.example.com"` | ArgoCD hostname to be exposed via Istio |
| argo-cd.server.extraArgs[0] | string | `"--insecure"` |  |
| argo-cd.server.logFormat | string | `"json"` |  |
| argo-cd.server.metrics.enabled | bool | `false` |  |
| argo-cd.server.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.service.servicePortHttpsName | string | `"grpc"` |  |
| argocd-applicationset.args.policy | string | `"create-update"` |  |
| argocd-applicationset.enabled | bool | `false` |  |
| argocd-applicationset.rbac.pspEnabled | bool | `false` |  |
| argocd-applicationset.resources.requests.cpu | string | `"50m"` |  |
| argocd-applicationset.resources.requests.memory | string | `"64Mi"` |  |
| istio.enabled | bool | `false` | Deploy Istio VirtualService to expose ArgoCD |
| istio.gateway | string | `"istio-ingress/ingressgateway"` | Name of the Istio gateway to add the VirtualService to |
| istio.ipBlocks | list | `[]` |  |

## Resources
- https://argoproj.github.io/argo-cd/operator-manual/metrics/
- https://raw.githubusercontent.com/argoproj/argo-cd/master/examples/dashboard.json
