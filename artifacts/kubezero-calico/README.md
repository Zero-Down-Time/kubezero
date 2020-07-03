# Calico CNI

Current top-level still contains the deprecated Canal implementation.
Removed once new AWS config is tested and rolled out to all existing clusters.

## AWS
Calico is setup based on the upstream calico-vxlan config from  
`https://docs.projectcalico.org/v3.15/manifests/calico-vxlan.yaml`

Changes:

- MTU set to 8941
- Disable BGB and BIRD healthchecks
- Set FELIX log level to warning
- Enable Prometheus metrics
