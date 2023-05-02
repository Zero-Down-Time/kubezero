# kubezero-network

![Version: 0.4.3](https://img.shields.io/badge/Version-0.4.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things network

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Stefan Reimer | <stefan@zero-downtime.net> |  |

## Requirements

Kubernetes: `>= 1.25.0`

| Repository | Name | Version |
|------------|------|---------|
| https://cdn.zero-downtime.net/charts/ | kubezero-lib | >= 0.1.6 |
| https://helm.cilium.io/ | cilium | 1.13.1 |
| https://metallb.github.io/metallb | metallb | 0.13.9 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cilium.cgroup.autoMount.enabled | bool | `false` |  |
| cilium.cgroup.hostRoot | string | `"/sys/fs/cgroup"` |  |
| cilium.cluster.id | int | `240` |  |
| cilium.cluster.name | string | `"default"` |  |
| cilium.cni.binPath | string | `"/usr/libexec/cni"` |  |
| cilium.cni.exclusive | bool | `false` |  |
| cilium.cni.logFile | string | `"/var/log/cilium-cni.log"` |  |
| cilium.containerRuntime.integration | string | `"crio"` |  |
| cilium.enabled | bool | `false` |  |
| cilium.hubble.enabled | bool | `false` |  |
| cilium.hubble.relay.enabled | bool | `false` |  |
| cilium.hubble.tls.auto.certManagerIssuerRef.group | string | `"cert-manager.io"` |  |
| cilium.hubble.tls.auto.certManagerIssuerRef.kind | string | `"ClusterIssuer"` |  |
| cilium.hubble.tls.auto.certManagerIssuerRef.name | string | `"kubezero-local-ca-issuer"` |  |
| cilium.hubble.tls.auto.method | string | `"cert-manager"` |  |
| cilium.hubble.ui.enabled | bool | `false` |  |
| cilium.ipam.operator.clusterPoolIPv4PodCIDRList[0] | string | `"10.240.0.0/16"` |  |
| cilium.l7Proxy | bool | `false` |  |
| cilium.operator.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cilium.operator.prometheus.enabled | bool | `false` |  |
| cilium.operator.prometheus.serviceMonitor.enabled | bool | `false` |  |
| cilium.operator.replicas | int | `1` |  |
| cilium.operator.tolerations[0].effect | string | `"NoSchedule"` |  |
| cilium.operator.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |
| cilium.operator.tolerations[1].effect | string | `"NoSchedule"` |  |
| cilium.operator.tolerations[1].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| cilium.prometheus.enabled | bool | `false` |  |
| cilium.prometheus.port | int | `9091` |  |
| cilium.prometheus.serviceMonitor.enabled | bool | `false` |  |
| cilium.resources.limits.memory | string | `"1024Mi"` |  |
| cilium.resources.requests.cpu | string | `"10m"` |  |
| cilium.resources.requests.memory | string | `"256Mi"` |  |
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
| multus.readinessindicatorfile | string | `"/etc/cni/net.d/05-cilium.conf"` |  |
| multus.tag | string | `"v3.9.3"` |  |
