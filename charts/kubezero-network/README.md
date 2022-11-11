# kubezero-network

![Version: 0.4.1](https://img.shields.io/badge/Version-0.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things network

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.24.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.5 |
| https://helm.cilium.io/ | cilium | 1.12.3 |
| https://metallb.github.io/metallb | metallb | 0.13.7 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cilium.bpf.hostLegacyRouting | bool | `true` |  |
| cilium.cgroup.autoMount.enabled | bool | `false` |  |
| cilium.cgroup.hostRoot | string | `"/sys/fs/cgroup"` |  |
| cilium.cluster.id | int | `240` |  |
| cilium.cluster.name | string | `"default"` |  |
| cilium.cni.binPath | string | `"/usr/libexec/cni"` |  |
| cilium.cni.logFile | string | `"/var/log/cilium-cni.log"` |  |
| cilium.containerRuntime.integration | string | `"crio"` |  |
| cilium.enabled | bool | `false` |  |
| cilium.hubble.enabled | bool | `false` |  |
| cilium.ipam.operator.clusterPoolIPv4PodCIDRList[0] | string | `"10.240.0.0/16"` |  |
| cilium.l7Proxy | bool | `false` |  |
| cilium.operator.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cilium.operator.replicas | int | `1` |  |
| cilium.operator.tolerations[0].effect | string | `"NoSchedule"` |  |
| cilium.operator.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cilium.operator.tolerations[1].effect | string | `"NoSchedule"` |  |
| cilium.operator.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| cilium.prometheus.enabled | bool | `false` |  |
| cilium.prometheus.port | int | `9091` |  |
| cilium.securityContext.privileged | bool | `true` |  |
| cilium.tunnel | string | `"geneve"` |  |
| metallb.controller.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| metallb.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| metallb.controller.tolerations[1].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| metallb.enabled | bool | `false` |  |
| metallb.ipAddressPools | list | `[]` |  |
| multus.clusterNetwork | string | `"cilium"` |  |
| multus.defaultNetworks | list | `[]` |  |
| multus.enabled | bool | `false` |  |
| multus.tag | string | `"v3.9.2"` |  |
