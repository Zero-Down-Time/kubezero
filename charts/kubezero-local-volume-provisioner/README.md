kubezero-local-volume-provisioner
=================================
KubeZero Umbrella Chart for local-static-provisioner

Provides persistent volumes backed by local volumes, eg. additional SSDs or spindles.

Current chart version is `0.0.1`

Source code can be found [here](https://kubezero.com)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://zero-down-time.github.io/kubezero/ | kubezero-lib | >= 0.1.1 |

## KubeZero default configuration

- add nodeSelector to only install on nodes actually having ephemeral local storage
- provide matching storage class to expose mounted disks under `/mnt/disks`

## Resources

- https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner
