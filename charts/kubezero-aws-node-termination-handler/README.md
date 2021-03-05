# kubezero-local-volume-provisioner

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.3.4](https://img.shields.io/badge/AppVersion-2.3.4-informational?style=flat-square)

KubeZero Umbrella Chart for local-static-provisioner

Provides persistent volumes backed by local volumes, eg. additional SSDs or spindles.

**Homepage:** <https://kubezero.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Quarky9 |  |  |

## Requirements

Kubernetes: `>= 1.16.0`

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| local-static-provisioner.classes[0].hostDir | string | `"/mnt/disks"` |  |
| local-static-provisioner.classes[0].name | string | `"local-sc-xfs"` |  |
| local-static-provisioner.common.namespace | string | `"kube-system"` |  |
| local-static-provisioner.daemonset.nodeSelector."node.kubernetes.io/localVolume" | string | `"present"` |  |
| local-static-provisioner.prometheus.operator.enabled | bool | `false` |  |

## KubeZero default configuration

- add nodeSelector to only install on nodes actually having ephemeral local storage
- provide matching storage class to expose mounted disks under `/mnt/disks`

## Resources

- https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner
