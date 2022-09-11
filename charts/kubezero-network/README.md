# kubezero-network

![Version: 0.3.2](https://img.shields.io/badge/Version-0.3.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things network

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.20.0`

| Repository | Name | Version |
|------------|------|---------|
|  | calico | 0.2.2 |
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.5 |
| https://helm.cilium.io/ | cilium | 1.12.1 |
| https://metallb.github.io/metallb | metallb | 0.13.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| calico.enabled | bool | `false` |  |
| cilium.cgroup.autoMount.enabled | bool | `false` |  |
| cilium.cgroup.hostRoot | string | `"/sys/fs/cgroup"` |  |
| cilium.cluster.id | int | `1` |  |
| cilium.cluster.name | string | `"default"` |  |
| cilium.cni.binPath | string | `"/usr/libexec/cni"` |  |
| cilium.cni.exclusive | bool | `false` |  |
| cilium.containerRuntime.integration | string | `"crio"` |  |
| cilium.enabled | bool | `false` |  |
| cilium.hubble.enabled | bool | `false` |  |
| cilium.ipam.operator.clusterPoolIPv4PodCIDRList[0] | string | `"10.1.0.0/16"` |  |
| cilium.l2NeighDiscovery.enabled | bool | `false` |  |
| cilium.l7Proxy | bool | `false` |  |
| cilium.nodePort.enabled | bool | `false` |  |
| cilium.operator.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cilium.operator.replicas | int | `1` |  |
| cilium.operator.tolerations[0].effect | string | `"NoSchedule"` |  |
| cilium.operator.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cilium.policyEnforcementMode | string | `"audit"` |  |
| cilium.prometheus.enabled | bool | `false` |  |
| cilium.prometheus.port | int | `9091` |  |
| cilium.securityContext.privileged | bool | `true` |  |
| cilium.tunnel | string | `"geneve"` |  |
| metallb.controller.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| metallb.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| metallb.enabled | bool | `false` |  |
| metallb.ipAddressPools | list | `[]` |  |
| metallb.psp.create | bool | `false` |  |
| multus.clusterNetwork | string | `"calico"` |  |
| multus.defaultNetworks | list | `[]` |  |
| multus.enabled | bool | `false` |  |
| multus.readinessindicatorfile | string | `"/etc/cni/net.d/10-calico.conflist"` |  |
| multus.tag | string | `"v3.9.1"` |  |
