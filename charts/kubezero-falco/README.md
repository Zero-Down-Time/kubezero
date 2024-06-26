# kubezero-falco

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Falco Container Security and Audit components

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.26.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |
| https://falcosecurity.github.io/charts | k8saudit(falco) | 4.2.5 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| k8saudit.collectors | object | `{"enabled":false}` | Disable the collectors, no syscall events to enrich with metadata. |
| k8saudit.controller | object | `{"deployment":{"replicas":1},"kind":"deployment"}` | Deploy Falco as a deployment. One instance of Falco is enough. Anyway the number of replicas is configurabale. |
| k8saudit.controller.deployment.replicas | int | `1` | Number of replicas when installing Falco using a deployment. Change it if you really know what you are doing. For more info check the section on Plugins in the README.md file. |
| k8saudit.driver | object | `{"enabled":false}` | Disable the drivers since we want to deploy only the k8saudit plugin. |
| k8saudit.enabled | bool | `false` |  |
| k8saudit.falco.buffered_outputs | bool | `true` |  |
| k8saudit.falco.json_output | bool | `true` |  |
| k8saudit.falco.load_plugins[0] | string | `"k8saudit"` |  |
| k8saudit.falco.load_plugins[1] | string | `"json"` |  |
| k8saudit.falco.log_syslog | bool | `false` |  |
| k8saudit.falco.plugins[0].init_config.maxEventSize | int | `1048576` |  |
| k8saudit.falco.plugins[0].library_path | string | `"libk8saudit.so"` |  |
| k8saudit.falco.plugins[0].name | string | `"k8saudit"` |  |
| k8saudit.falco.plugins[0].open_params | string | `"http://:9765/k8s-audit"` |  |
| k8saudit.falco.plugins[1].init_config | string | `""` |  |
| k8saudit.falco.plugins[1].library_path | string | `"libjson.so"` |  |
| k8saudit.falco.plugins[1].name | string | `"json"` |  |
| k8saudit.falco.rules_file[0] | string | `"/etc/falco/rules.d"` |  |
| k8saudit.falco.syslog_output.enabled | bool | `false` |  |
| k8saudit.falcoctl.artifact.follow.enabled | bool | `false` |  |
| k8saudit.falcoctl.artifact.install.enabled | bool | `false` |  |
| k8saudit.fullnameOverride | string | `"falco-k8saudit"` |  |
| k8saudit.mounts.volumeMounts[0].mountPath | string | `"/etc/falco/rules.d"` |  |
| k8saudit.mounts.volumeMounts[0].name | string | `"rules-volume"` |  |
| k8saudit.mounts.volumes[0].configMap.name | string | `"falco-k8saudit-rules"` |  |
| k8saudit.mounts.volumes[0].name | string | `"rules-volume"` |  |
| k8saudit.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| k8saudit.resources.limits.cpu | string | `"1000m"` |  |
| k8saudit.resources.limits.memory | string | `"512Mi"` |  |
| k8saudit.resources.requests.cpu | string | `"100m"` |  |
| k8saudit.resources.requests.memory | string | `"256Mi"` |  |
| k8saudit.services[0].name | string | `"webhook"` |  |
| k8saudit.services[0].ports[0].port | int | `9765` |  |
| k8saudit.services[0].ports[0].protocol | string | `"TCP"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
