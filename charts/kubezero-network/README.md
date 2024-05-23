# kubezero-network

![Version: 0.5.2](https://img.shields.io/badge/Version-0.5.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

KubeZero umbrella chart for all things network

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
| https://haproxytech.github.io/helm-charts | haproxy | 1.22.0 |
| https://helm.cilium.io/ | cilium | 1.15.5 |
| https://metallb.github.io/metallb | metallb | 0.14.5 |

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
| cilium.enabled | bool | `false` |  |
| cilium.hubble.enabled | bool | `false` |  |
| cilium.hubble.relay.enabled | bool | `false` |  |
| cilium.hubble.tls.auto.certManagerIssuerRef.group | string | `"cert-manager.io"` |  |
| cilium.hubble.tls.auto.certManagerIssuerRef.kind | string | `"ClusterIssuer"` |  |
| cilium.hubble.tls.auto.certManagerIssuerRef.name | string | `"kubezero-local-ca-issuer"` |  |
| cilium.hubble.tls.auto.method | string | `"cert-manager"` |  |
| cilium.hubble.ui.enabled | bool | `false` |  |
| cilium.image.useDigest | bool | `false` |  |
| cilium.ipam.operator.clusterPoolIPv4PodCIDRList[0] | string | `"10.240.0.0/16"` |  |
| cilium.l7Proxy | bool | `false` |  |
| cilium.operator.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| cilium.operator.prometheus.enabled | bool | `false` |  |
| cilium.operator.prometheus.serviceMonitor.enabled | bool | `false` |  |
| cilium.operator.replicas | int | `1` |  |
| cilium.operator.tolerations[0].effect | string | `"NoSchedule"` |  |
| cilium.operator.tolerations[0].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| cilium.operator.tolerations[1].effect | string | `"NoSchedule"` |  |
| cilium.operator.tolerations[1].key | string | `"node.cilium.io/agent-not-ready"` |  |
| cilium.prometheus.enabled | bool | `false` |  |
| cilium.prometheus.port | int | `9091` |  |
| cilium.prometheus.serviceMonitor.enabled | bool | `false` |  |
| cilium.resources.limits.memory | string | `"1024Mi"` |  |
| cilium.resources.requests.cpu | string | `"10m"` |  |
| cilium.resources.requests.memory | string | `"256Mi"` |  |
| cilium.tunnelProtocol | string | `"geneve"` |  |
| metallb.controller.nodeSelector."node-role.kubernetes.io/control-plane" | string | `""` |  |
| metallb.controller.tolerations[0].effect | string | `"NoSchedule"` |  |
| metallb.controller.tolerations[0].key | string | `"node-role.kubernetes.io/control-plane"` |  |
| metallb.enabled | bool | `false` |  |
| metallb.ipAddressPools | list | `[]` |  |
| multus.clusterNetwork | string | `"cilium"` |  |
| multus.defaultNetworks | list | `[]` |  |
| multus.enabled | bool | `false` |  |
| multus.image.repository | string | `"ghcr.io/k8snetworkplumbingwg/multus-cni"` |  |
| multus.image.tag | string | `"v3.9.3"` |  |
| multus.readinessindicatorfile | string | `"/etc/cni/net.d/05-cilium.conflist"` |  |
