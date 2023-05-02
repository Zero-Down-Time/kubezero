# kubezero-ci

![Version: 0.6.2](https://img.shields.io/badge/Version-0.6.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things CI

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.24.0`

| Repository | Name | Version |
|------------|------|---------|
| https://aquasecurity.github.io/helm-charts/ | trivy | 0.7.0 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |
| https://charts.jenkins.io | jenkins | 4.3.20 |
| https://dl.gitea.io/charts/ | gitea | 8.2.0 |
| https://gocd.github.io/helm-chart | gocd | 1.40.8 |

# Jenkins
- default build retention 10 builds, 32days
- memory request 1.25GB
- dark theme
- trivy scanner incl. HTML reporting and publisher

# goCD

# Gitea

## OpenSSH 8.8 RSA disabled
- https://github.com/go-gitea/gitea/issues/17798

## Resources

### JVM tuning in containers
- https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers?extIdCarryOver=true&sc_cid=701f2000001Css5AAC

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gitea.enabled | bool | `false` |  |
| gitea.gitea.admin.existingSecret | string | `"gitea-admin-secret"` |  |
| gitea.gitea.config.cache.ADAPTER | string | `"memory"` |  |
| gitea.gitea.config.database.DB_TYPE | string | `"sqlite3"` |  |
| gitea.gitea.demo | bool | `false` |  |
| gitea.gitea.metrics.enabled | bool | `false` |  |
| gitea.gitea.metrics.serviceMonitor.enabled | bool | `true` |  |
| gitea.image.rootless | bool | `true` |  |
| gitea.istio.enabled | bool | `false` |  |
| gitea.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| gitea.istio.url | string | `"git.example.com"` |  |
| gitea.mariadb.enabled | bool | `false` |  |
| gitea.memcached.enabled | bool | `false` |  |
| gitea.mysql.enabled | bool | `false` |  |
| gitea.persistence.enabled | bool | `true` |  |
| gitea.persistence.size | string | `"4Gi"` |  |
| gitea.postgresql.enabled | bool | `false` |  |
| gitea.resources.limits.memory | string | `"2048Mi"` |  |
| gitea.resources.requests.cpu | string | `"150m"` |  |
| gitea.resources.requests.memory | string | `"320Mi"` |  |
| gitea.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| gitea.securityContext.capabilities.add[0] | string | `"SYS_CHROOT"` |  |
| gitea.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| gocd.enabled | bool | `false` |  |
| gocd.istio.enabled | bool | `false` |  |
| gocd.istio.gateway | string | `"istio-ingress/private-ingressgateway"` |  |
| gocd.istio.url | string | `""` |  |
| gocd.server.ingress.enabled | bool | `false` |  |
| gocd.server.service.type | string | `"ClusterIP"` |  |
| jenkins.agent.annotations."container.apparmor.security.beta.kubernetes.io/jnlp" | string | `"unconfined"` |  |
| jenkins.agent.containerCap | int | `2` |  |
| jenkins.agent.customJenkinsLabels[0] | string | `"podman-aws-trivy"` |  |
| jenkins.agent.idleMinutes | int | `15` |  |
| jenkins.agent.image | string | `"public.ecr.aws/zero-downtime/jenkins-podman"` |  |
| jenkins.agent.podName | string | `"podman-aws"` |  |
| jenkins.agent.podRetention | string | `"Default"` |  |
| jenkins.agent.resources.limits.cpu | string | `""` |  |
| jenkins.agent.resources.limits.memory | string | `""` |  |
| jenkins.agent.resources.requests.cpu | string | `""` |  |
| jenkins.agent.resources.requests.memory | string | `""` |  |
| jenkins.agent.showRawYaml | bool | `false` |  |
| jenkins.agent.tag | string | `"v0.4.1"` |  |
| jenkins.agent.yamlMergeStrategy | string | `"merge"` |  |
| jenkins.agent.yamlTemplate | string | `"apiVersion: v1\nkind: Pod\nspec:\n  securityContext:\n    fsGroup: 1000\n  serviceAccountName: jenkins-podman-aws\n  containers:\n  - name: jnlp\n    resources:\n      requests:\n        cpu: \"512m\"\n        memory: \"1024Mi\"\n      limits:\n        cpu: \"4\"\n        memory: \"6144Mi\"\n        github.com/fuse: 1\n    volumeMounts:\n    - name: aws-token\n      mountPath: \"/var/run/secrets/sts.amazonaws.com/serviceaccount/\"\n      readOnly: true\n    - name: host-registries-conf\n      mountPath: \"/home/jenkins/.config/containers/registries.conf\"\n      readOnly: true\n  volumes:\n  - name: aws-token\n    projected:\n      sources:\n      - serviceAccountToken:\n          path: token\n          expirationSeconds: 86400\n          audience: \"sts.amazonaws.com\"\n  - name: host-registries-conf\n    hostPath:\n      path: /etc/containers/registries.conf\n      type: File"` |  |
| jenkins.controller.JCasC.configScripts.zdt-settings | string | `"jenkins:\n  noUsageStatistics: true\n  disabledAdministrativeMonitors:\n  - \"jenkins.security.ResourceDomainRecommendation\"\nunclassified:\n  buildDiscarders:\n    configuredBuildDiscarders:\n    - \"jobBuildDiscarder\"\n    - defaultBuildDiscarder:\n        discarder:\n          logRotator:\n            artifactDaysToKeepStr: \"32\"\n            artifactNumToKeepStr: \"10\"\n            daysToKeepStr: \"100\"\n            numToKeepStr: \"10\"\n"` |  |
| jenkins.controller.disableRememberMe | bool | `true` |  |
| jenkins.controller.enableRawHtmlMarkupFormatter | bool | `true` |  |
| jenkins.controller.initContainerResources.limits.memory | string | `"1024Mi"` |  |
| jenkins.controller.initContainerResources.requests.cpu | string | `"50m"` |  |
| jenkins.controller.initContainerResources.requests.memory | string | `"256Mi"` |  |
| jenkins.controller.installPlugins[0] | string | `"kubernetes:3910.ve59cec5e33ea_"` |  |
| jenkins.controller.installPlugins[10] | string | `"build-discarder:139.v05696a_7fe240"` |  |
| jenkins.controller.installPlugins[11] | string | `"dark-theme:315.va_22e7d692ea_a"` |  |
| jenkins.controller.installPlugins[12] | string | `"kubernetes-credentials-provider:1.211.vc236a_f5a_2f3c"` |  |
| jenkins.controller.installPlugins[1] | string | `"workflow-aggregator:581.v0c46fa_697ffd"` |  |
| jenkins.controller.installPlugins[2] | string | `"git:5.0.0"` |  |
| jenkins.controller.installPlugins[3] | string | `"basic-branch-build-strategies:71.vc1421f89888e"` |  |
| jenkins.controller.installPlugins[4] | string | `"pipeline-graph-view:183.v9e27732d970f"` |  |
| jenkins.controller.installPlugins[5] | string | `"pipeline-stage-view:2.32"` |  |
| jenkins.controller.installPlugins[6] | string | `"configuration-as-code:1625.v27444588cc3d"` |  |
| jenkins.controller.installPlugins[7] | string | `"antisamy-markup-formatter:159.v25b_c67cd35fb_"` |  |
| jenkins.controller.installPlugins[8] | string | `"prometheus:2.2.1"` |  |
| jenkins.controller.installPlugins[9] | string | `"htmlpublisher:1.31"` |  |
| jenkins.controller.javaOpts | string | `"-XX:+UseContainerSupport -XX:+UseStringDeduplication -Dhudson.model.DirectoryBrowserSupport.CSP=\"sandbox allow-popups; default-src 'none'; img-src 'self' cdn.zero-downtime.net; style-src 'unsafe-inline';\""` |  |
| jenkins.controller.jenkinsOpts | string | `"--sessionTimeout=180 --sessionEviction=3600"` |  |
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
| trivy.enabled | bool | `false` |  |
| trivy.image.tag | string | `"0.39.1"` |  |
| trivy.persistence.enabled | bool | `true` |  |
| trivy.persistence.size | string | `"1Gi"` |  |
| trivy.rbac.create | bool | `false` |  |
