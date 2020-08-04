# CFN / Platform
- Kube to 1.17
- Kube-proxy uses ipvs
- metrics support for kube-proxy
- no reliance on custom resource for S3 buckets anymore


# Kubezero
- fully automated one command bootstrap incl. all kubezero components 
- migrated from kube-prometheuss to community helm charts for metrics
- latest Grafana incl. peristence
- kube-prometheus adapter improvements / customizations
- integrated EFS CSI driver into Kubezero
- prometheus itself can be exposed via istio ingress on demand to ease development of custom metrics
