# kubezero-argo

![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square)

KubeZero Argo - Events, Workflow, CD

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.26.0`

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 7.3.8 |
| https://argoproj.github.io/argo-helm | argo-events | 2.4.7 |
| https://argoproj.github.io/argo-helm | argocd-apps | 2.0.0 |
| https://argoproj.github.io/argo-helm | argocd-image-updater | 0.11.0 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.configs.cm."resource.customizations" | string | `"cert-manager.io/Certificate:\n  # Lua script for customizing the health status assessment\n  health.lua: |\n    hs = {}\n    if obj.status ~= nil then\n      if obj.status.conditions ~= nil then\n        for i, condition in ipairs(obj.status.conditions) do\n          if condition.type == \"Ready\" and condition.status == \"False\" then\n            hs.status = \"Degraded\"\n            hs.message = condition.message\n            return hs\n          end\n          if condition.type == \"Ready\" and condition.status == \"True\" then\n            hs.status = \"Healthy\"\n            hs.message = condition.message\n            return hs\n          end\n        end\n      end\n    end\n    hs.status = \"Progressing\"\n    hs.message = \"Waiting for certificate\"\n    return hs\n"` |  |
| argo-cd.configs.cm."timeout.reconciliation" | string | `"300s"` |  |
| argo-cd.configs.cm."ui.bannercontent" | string | `"KubeZero v1.29 - Release notes"` |  |
| argo-cd.configs.cm."ui.bannerpermanent" | string | `"true"` |  |
| argo-cd.configs.cm."ui.bannerposition" | string | `"bottom"` |  |
| argo-cd.configs.cm."ui.bannerurl" | string | `"https://kubezero.com/releases/v1.29"` |  |
| argo-cd.configs.cm.url | string | `"https://argocd.example.com"` |  |
| argo-cd.configs.params."controller.operation.processors" | string | `"5"` |  |
| argo-cd.configs.params."controller.status.processors" | string | `"10"` |  |
| argo-cd.configs.params."server.enable.gzip" | bool | `true` |  |
| argo-cd.configs.params."server.insecure" | bool | `true` |  |
| argo-cd.configs.secret.createSecret | bool | `false` |  |
| argo-cd.configs.ssh.extraHosts | string | `"git.zero-downtime.net ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8YdJ4YcOK7A0K7qOWsRjCS+wHTStXRcwBe7gjG43HPSNijiCKoGf/c+tfNsRhyouawg7Law6M6ahmS/jKWBpznRIM+OdOFVSuhnK/nr6h6wG3/ZfdLicyAPvx1/STGY/Fc6/zXA88i/9PV+g84gSVmhf3fGY92wokiASiu9DU4T9dT1gIkdyOX6fbMi1/mMKLSrHnAQcjyasYDvw9ISCJ95EoSwbj7O4c+7jo9fxYvdCfZZZAEZGozTRLAAO0AnjVcRah7bZV/jfHJuhOipV/TB7UVAhlVv1dfGV7hoTp9UKtKZFJF4cjIrSGxqQA/mdhSdLgkepK7yc4Jp2xGnaarhY29DfqsQqop+ugFpTbj7Xy5Rco07mXc6XssbAZhI1xtCOX20N4PufBuYippCK5AE6AiAyVtJmvfGQk4HP+TjOyhFo7PZm3wc9Hym7IBBVC0Sl30K8ddufkAgHwNGvvu1ZmD9ZWaMOXJDHBCZGMMr16QREZwVtZTwMEQalc7/yqmuqMhmcJIfs/GA2Lt91y+pq9C8XyeUL0VFPch0vkcLSRe3ghMZpRFJ/ht307xPcLzgTJqN6oQtNNDzSQglSEjwhge2K4GyWcIh+oGsWxWz5dHyk1iJmw90Y976BZIl/mYVgbTtZAJ81oGe/0k5rAe+LDL+Yq6tG28QFOg0QmiQ=="` |  |
| argo-cd.configs.styles | string | `".sidebar__logo img { content: url(https://cdn.zero-downtime.net/assets/kubezero/logo-small-64.png); }\n.sidebar__logo__text-logo { height: 0em; }\n.sidebar { background: linear-gradient(to bottom, #6A4D79, #493558, #2D1B30, #0D0711); }\n"` |  |
| argo-cd.controller.metrics.enabled | bool | `false` |  |
| argo-cd.controller.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.controller.resources.limits.memory | string | `"2048Mi"` |  |
| argo-cd.controller.resources.requests.cpu | string | `"100m"` |  |
| argo-cd.controller.resources.requests.memory | string | `"512Mi"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.enabled | bool | `false` |  |
| argo-cd.global.image.repository | string | `"public.ecr.aws/zero-downtime/zdt-argocd"` |  |
| argo-cd.global.image.tag | string | `"v2.11.0"` |  |
| argo-cd.global.logging.format | string | `"json"` |  |
| argo-cd.istio.enabled | bool | `false` |  |
| argo-cd.istio.gateway | string | `"istio-ingress/ingressgateway"` |  |
| argo-cd.istio.ipBlocks | list | `[]` |  |
| argo-cd.notifications.enabled | bool | `false` |  |
| argo-cd.repoServer.clusterRoleRules.enabled | bool | `true` |  |
| argo-cd.repoServer.clusterRoleRules.rules[0].apiGroups[0] | string | `""` |  |
| argo-cd.repoServer.clusterRoleRules.rules[0].resources[0] | string | `"secrets"` |  |
| argo-cd.repoServer.clusterRoleRules.rules[0].verbs[0] | string | `"get"` |  |
| argo-cd.repoServer.clusterRoleRules.rules[0].verbs[1] | string | `"watch"` |  |
| argo-cd.repoServer.clusterRoleRules.rules[0].verbs[2] | string | `"list"` |  |
| argo-cd.repoServer.initContainers[0].command[0] | string | `"/usr/local/bin/sa2kubeconfig.sh"` |  |
| argo-cd.repoServer.initContainers[0].command[1] | string | `"/home/argocd/.kube/config"` |  |
| argo-cd.repoServer.initContainers[0].image | string | `"public.ecr.aws/zero-downtime/zdt-argocd:v2.11.0"` |  |
| argo-cd.repoServer.initContainers[0].imagePullPolicy | string | `"IfNotPresent"` |  |
| argo-cd.repoServer.initContainers[0].name | string | `"create-kubeconfig"` |  |
| argo-cd.repoServer.initContainers[0].securityContext.allowPrivilegeEscalation | bool | `false` |  |
| argo-cd.repoServer.initContainers[0].securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| argo-cd.repoServer.initContainers[0].securityContext.readOnlyRootFilesystem | bool | `true` |  |
| argo-cd.repoServer.initContainers[0].securityContext.runAsNonRoot | bool | `true` |  |
| argo-cd.repoServer.initContainers[0].securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| argo-cd.repoServer.initContainers[0].volumeMounts[0].mountPath | string | `"/home/argocd/.kube"` |  |
| argo-cd.repoServer.initContainers[0].volumeMounts[0].name | string | `"kubeconfigs"` |  |
| argo-cd.repoServer.metrics.enabled | bool | `false` |  |
| argo-cd.repoServer.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.repoServer.volumeMounts[0].mountPath | string | `"/home/argocd/.kube"` |  |
| argo-cd.repoServer.volumeMounts[0].name | string | `"kubeconfigs"` |  |
| argo-cd.repoServer.volumes[0].emptyDir | object | `{}` |  |
| argo-cd.repoServer.volumes[0].name | string | `"kubeconfigs"` |  |
| argo-cd.server.metrics.enabled | bool | `false` |  |
| argo-cd.server.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.service.servicePortHttpsName | string | `"grpc"` |  |
| argo-events.configs.jetstream.settings.maxFileStore | int | `-1` | Maximum size of the file storage (e.g. 20G) |
| argo-events.configs.jetstream.settings.maxMemoryStore | int | `-1` | Maximum size of the memory storage (e.g. 1G) |
| argo-events.configs.jetstream.streamConfig.duplicates | string | `"300s"` | Not documented at the moment |
| argo-events.configs.jetstream.streamConfig.maxAge | string | `"72h"` | Maximum age of existing messages, i.e. “72h”, “4h35m” |
| argo-events.configs.jetstream.streamConfig.maxBytes | string | `"1GB"` |  |
| argo-events.configs.jetstream.streamConfig.maxMsgs | int | `1000000` | Maximum number of messages before expiring oldest message |
| argo-events.configs.jetstream.streamConfig.replicas | int | `1` | Number of replicas, defaults to 3 and requires minimal 3 |
| argo-events.configs.jetstream.versions[0].configReloaderImage | string | `"natsio/nats-server-config-reloader:0.14.1"` |  |
| argo-events.configs.jetstream.versions[0].metricsExporterImage | string | `"natsio/prometheus-nats-exporter:0.14.0"` |  |
| argo-events.configs.jetstream.versions[0].natsImage | string | `"nats:2.10.11-scratch"` |  |
| argo-events.configs.jetstream.versions[0].startCommand | string | `"/nats-server"` |  |
| argo-events.configs.jetstream.versions[0].version | string | `"2.10.11"` |  |
| argo-events.enabled | bool | `false` |  |
| argocd-apps.applications | object | `{}` |  |
| argocd-apps.enabled | bool | `false` |  |
| argocd-apps.projects | object | `{}` |  |
| argocd-image-updater.authScripts.enabled | bool | `true` |  |
| argocd-image-updater.authScripts.scripts."ecr-login.sh" | string | `"#!/bin/sh\naws ecr --region $AWS_REGION get-authorization-token --output text --query 'authorizationData[].authorizationToken' | base64 -d\n"` |  |
| argocd-image-updater.authScripts.scripts."ecr-public-login.sh" | string | `"#!/bin/sh\naws ecr-public --region us-east-1 get-authorization-token --output text --query 'authorizationData.authorizationToken' | base64 -d\n"` |  |
| argocd-image-updater.config.argocd.plaintext | bool | `true` |  |
| argocd-image-updater.enabled | bool | `false` |  |
| argocd-image-updater.fullnameOverride | string | `"argocd-image-updater"` |  |
| argocd-image-updater.metrics.enabled | bool | `false` |  |
| argocd-image-updater.metrics.serviceMonitor.enabled | bool | `true` |  |
| argocd-image-updater.sshConfig.config | string | `"Host *\n  PubkeyAcceptedAlgorithms +ssh-rsa\n  HostkeyAlgorithms +ssh-rsa\n"` |  |

## Resources
- https://github.com/argoproj/argoproj/blob/main/docs/end_user_threat_model.pdf
- https://argoproj.github.io/argo-cd/operator-manual/metrics/
- https://raw.githubusercontent.com/argoproj/argo-cd/master/examples/dashboard.json

