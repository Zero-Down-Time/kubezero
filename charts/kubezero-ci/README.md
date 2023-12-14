# kubezero-ci

![Version: 0.8.5](https://img.shields.io/badge/Version-0.8.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things CI

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.25.0`

| Repository | Name | Version |
|------------|------|---------|
| https://aquasecurity.github.io/helm-charts/ | trivy | 0.7.0 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |
| https://charts.jenkins.io | jenkins | 4.9.2 |
| https://dl.gitea.io/charts/ | gitea | 9.6.1 |
| https://docs.renovatebot.com/helm-charts | renovate | 37.92.4 |

# Jenkins
- default build retention 10 builds, 32days
- memory request 1.25GB
- dark theme
- trivy scanner incl. HTML reporting and publisher

# goCD

# Gitea

# Verdaccio

## Authentication sealed-secret
```htpasswd -n -b -B -C 4 <username> <password> | kubeseal --raw --namespace verdaccio --name verdaccio-htpasswd```

## Resources

### JVM tuning in containers
- https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers?extIdCarryOver=true&sc_cid=701f2000001Css5AAC

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gitea.checkDeprecation | bool | `false` |  |
| gitea.enabled | bool | `false` |  |
| gitea.extraVolumeMounts[0].mountPath | string | `"/data/gitea/public/assets/css"` |  |
| gitea.extraVolumeMounts[0].name | string | `"gitea-themes"` |  |
| gitea.extraVolumeMounts[0].readOnly | bool | `true` |  |
| gitea.extraVolumes[0].configMap.name | string | `"gitea-kubezero-ci-themes"` |  |
| gitea.extraVolumes[0].name | string | `"gitea-themes"` |  |
| gitea.gitea.admin.existingSecret | string | `"gitea-admin-secret"` |  |
| gitea.gitea.config.cache.ADAPTER | string | `"memory"` |  |
| gitea.gitea.config.database.DB_TYPE | string | `"sqlite3"` |  |
| gitea.gitea.config.queue.TYPE | string | `"level"` |  |
| gitea.gitea.config.session.PROVIDER | string | `"memory"` |  |
| gitea.gitea.config.ui.DEFAULT_THEME | string | `"github-dark"` |  |
| gitea.gitea.config.ui.THEMES | string | `"gitea,github-dark"` |  |
| gitea.gitea.demo | bool | `false` |  |
| gitea.gitea.metrics.enabled | bool | `false` |  |
| gitea.gitea.metrics.serviceMonitor.enabled | bool | `true` |  |
| gitea.image.rootless | bool | `true` |  |
| gitea.image.tag | string | `"1.21.2"` |  |
| gitea.istio.enabled | bool | `false` |  |
| gitea.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| gitea.istio.url | string | `"git.example.com"` |  |
| gitea.persistence.create | bool | `false` |  |
| gitea.persistence.enabled | bool | `true` |  |
| gitea.persistence.mount | bool | `true` |  |
| gitea.persistence.size | string | `"4Gi"` |  |
| gitea.postgresql-ha.enabled | bool | `false` |  |
| gitea.postgresql.enabled | bool | `false` |  |
| gitea.redis-cluster.enabled | bool | `false` |  |
| gitea.repliaCount | int | `1` |  |
| gitea.resources.limits.memory | string | `"2048Mi"` |  |
| gitea.resources.requests.cpu | string | `"150m"` |  |
| gitea.resources.requests.memory | string | `"320Mi"` |  |
| gitea.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| gitea.securityContext.capabilities.add[0] | string | `"SYS_CHROOT"` |  |
| gitea.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| gitea.strategy.type | string | `"Recreate"` |  |
| gitea.test.enabled | bool | `false` |  |
| jenkins.agent.annotations."container.apparmor.security.beta.kubernetes.io/jnlp" | string | `"unconfined"` |  |
| jenkins.agent.containerCap | int | `2` |  |
| jenkins.agent.customJenkinsLabels[0] | string | `"podman-aws-trivy"` |  |
| jenkins.agent.idleMinutes | int | `30` |  |
| jenkins.agent.image | string | `"public.ecr.aws/zero-downtime/jenkins-podman"` |  |
| jenkins.agent.podName | string | `"podman-aws"` |  |
| jenkins.agent.podRetention | string | `"Default"` |  |
| jenkins.agent.resources.limits.cpu | string | `""` |  |
| jenkins.agent.resources.limits.memory | string | `""` |  |
| jenkins.agent.resources.requests.cpu | string | `""` |  |
| jenkins.agent.resources.requests.memory | string | `""` |  |
| jenkins.agent.showRawYaml | bool | `false` |  |
| jenkins.agent.tag | string | `"v0.4.6"` |  |
| jenkins.agent.yamlMergeStrategy | string | `"merge"` |  |
| jenkins.agent.yamlTemplate | string | `"apiVersion: v1\nkind: Pod\nspec:\n  securityContext:\n    fsGroup: 1000\n  serviceAccountName: jenkins-podman-aws\n  containers:\n  - name: jnlp\n    resources:\n      requests:\n        cpu: \"512m\"\n        memory: \"1024Mi\"\n      limits:\n        cpu: \"4\"\n        memory: \"6144Mi\"\n        github.com/fuse: 1\n    volumeMounts:\n    - name: aws-token\n      mountPath: \"/var/run/secrets/sts.amazonaws.com/serviceaccount/\"\n      readOnly: true\n    - name: host-registries-conf\n      mountPath: \"/home/jenkins/.config/containers/registries.conf\"\n      readOnly: true\n  volumes:\n  - name: aws-token\n    projected:\n      sources:\n      - serviceAccountToken:\n          path: token\n          expirationSeconds: 86400\n          audience: \"sts.amazonaws.com\"\n  - name: host-registries-conf\n    hostPath:\n      path: /etc/containers/registries.conf\n      type: File"` |  |
| jenkins.controller.JCasC.configScripts.zdt-settings | string | `"jenkins:\n  noUsageStatistics: true\n  disabledAdministrativeMonitors:\n  - \"jenkins.security.ResourceDomainRecommendation\"\nappearance:\n  themeManager:\n    disableUserThemes: true\n    theme: \"dark\"\nunclassified:\n  buildDiscarders:\n    configuredBuildDiscarders:\n    - \"jobBuildDiscarder\"\n    - defaultBuildDiscarder:\n        discarder:\n          logRotator:\n            artifactDaysToKeepStr: \"32\"\n            artifactNumToKeepStr: \"10\"\n            daysToKeepStr: \"100\"\n            numToKeepStr: \"10\"\n"` |  |
| jenkins.controller.disableRememberMe | bool | `true` |  |
| jenkins.controller.enableRawHtmlMarkupFormatter | bool | `true` |  |
| jenkins.controller.initContainerResources.limits.memory | string | `"1024Mi"` |  |
| jenkins.controller.initContainerResources.requests.cpu | string | `"50m"` |  |
| jenkins.controller.initContainerResources.requests.memory | string | `"256Mi"` |  |
| jenkins.controller.installPlugins[0] | string | `"kubernetes"` |  |
| jenkins.controller.installPlugins[10] | string | `"htmlpublisher"` |  |
| jenkins.controller.installPlugins[11] | string | `"build-discarder"` |  |
| jenkins.controller.installPlugins[12] | string | `"dark-theme"` |  |
| jenkins.controller.installPlugins[13] | string | `"matrix-auth"` |  |
| jenkins.controller.installPlugins[1] | string | `"kubernetes-credentials-provider"` |  |
| jenkins.controller.installPlugins[2] | string | `"workflow-aggregator"` |  |
| jenkins.controller.installPlugins[3] | string | `"git"` |  |
| jenkins.controller.installPlugins[4] | string | `"basic-branch-build-strategies"` |  |
| jenkins.controller.installPlugins[5] | string | `"pipeline-graph-view"` |  |
| jenkins.controller.installPlugins[6] | string | `"pipeline-stage-view"` |  |
| jenkins.controller.installPlugins[7] | string | `"configuration-as-code"` |  |
| jenkins.controller.installPlugins[8] | string | `"antisamy-markup-formatter"` |  |
| jenkins.controller.installPlugins[9] | string | `"prometheus"` |  |
| jenkins.controller.javaOpts | string | `"-XX:+UseContainerSupport -XX:+UseStringDeduplication -Dhudson.model.DirectoryBrowserSupport.CSP=\"sandbox allow-popups; default-src 'none'; img-src 'self' cdn.zero-downtime.net; style-src 'unsafe-inline';\""` |  |
| jenkins.controller.jenkinsOpts | string | `"--sessionTimeout=300 --sessionEviction=10800"` |  |
| jenkins.controller.prometheus.enabled | bool | `false` |  |
| jenkins.controller.resources.limits.memory | string | `"4096Mi"` |  |
| jenkins.controller.resources.requests.cpu | string | `"250m"` |  |
| jenkins.controller.resources.requests.memory | string | `"1280Mi"` |  |
| jenkins.controller.tag | string | `"alpine-jdk17"` |  |
| jenkins.controller.testEnabled | bool | `false` |  |
| jenkins.enabled | bool | `false` |  |
| jenkins.istio.agent.enabled | bool | `false` |  |
| jenkins.istio.agent.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| jenkins.istio.agent.url | string | `"jenkins-agent.example.com"` |  |
| jenkins.istio.enabled | bool | `false` |  |
| jenkins.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| jenkins.istio.url | string | `"jenkins.example.com"` |  |
| jenkins.istio.webhook.enabled | bool | `false` |  |
| jenkins.istio.webhook.gateway | string | `"istio-ingress/ingressgateway"` |  |
| jenkins.istio.webhook.url | string | `"jenkins-webhook.example.com"` |  |
| jenkins.persistence.size | string | `"4Gi"` |  |
| jenkins.rbac.readSecrets | bool | `true` |  |
| jenkins.serviceAccountAgent.create | bool | `true` |  |
| jenkins.serviceAccountAgent.name | string | `"jenkins-podman-aws"` |  |
| renovate.cronjob.concurrencyPolicy | string | `"Forbid"` |  |
| renovate.cronjob.jobBackoffLimit | int | `3` |  |
| renovate.cronjob.schedule | string | `"0 3 * * *"` |  |
| renovate.cronjob.successfulJobsHistoryLimit | int | `1` |  |
| renovate.enabled | bool | `false` |  |
| renovate.env.LOG_FORMAT | string | `"json"` |  |
| renovate.securityContext.fsGroup | int | `1000` |  |
| trivy.enabled | bool | `false` |  |
| trivy.image.tag | string | `"0.47.0"` |  |
| trivy.persistence.enabled | bool | `true` |  |
| trivy.persistence.size | string | `"1Gi"` |  |
| trivy.rbac.create | bool | `false` |  |
