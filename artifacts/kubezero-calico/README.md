# Calico CNI

Current top-level still contains the deprecated Canal implementation.
Removed once new AWS config is tested and rolled out to all existing clusters.

## AWS
Calico is setup based on the upstream calico-vxlan config from  
`https://docs.projectcalico.org/v3.15/manifests/calico-vxlan.yaml`

Changes:

- VxLAN set to Always to not expose cluster communication to VPC  

    -> EC2 SecurityGroups still apply and only need to allow UDP 4789 for VxLAN traffic  
    -> No need to disable source/destination check on EC2 instances  
    -> Prepared for optional WireGuard encryption for all inter node traffic

- MTU set to 8941

- Removed migration init-container

- Disable BGB and BIRD health checks

- Set FELIX log level to warning

- Enable Prometheus metrics
