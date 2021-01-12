# kubezero-local-path-provisioner

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.18](https://img.shields.io/badge/AppVersion-0.0.18-informational?style=flat-square)

KubeZero Umbrella Chart for local-path-provisioner

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
| local-path-provisioner.nodePathMap[0].node | string | `"DEFAULT_PATH_FOR_NON_LISTED_NODES"` |  |
| local-path-provisioner.nodePathMap[0].paths[0] | string | `"/opt/local-path-provisioner"` |  |
| local-path-provisioner.nodeSelector."node-role.kubernetes.io/master" | string | `""` |  |
| local-path-provisioner.storageClass.create | bool | `true` |  |
| local-path-provisioner.storageClass.defaultClass | bool | `false` |  |
| local-path-provisioner.tolerations[0].effect | string | `"NoSchedule"` |  |
| local-path-provisioner.tolerations[0].key | string | `"node-role.kubernetes.io/master"` |  |

## KubeZero default configuration

- add nodeSelector to only install on nodes actually having ephemeral local storage
- provide matching storage class to expose mounted disks under `/mnt/disks`

## Resources

- https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner
