# Quickstart    
---

# CloudBender

## Prepare Config
- check config/kube/kube-control-plane.yaml
- check config/kube/kube-workers.yaml

## Deploy Cluster
- cloudbender sync config/kube --multi  

## Get kubectl config
- get admin.conf from S3 and store in your local `~/.kube` folder  
  S3 URL will also be in the Slack message after successful bootstrap !

## Verify nodes
- Verify all nodes have the expected version and are *Ready*, eg via: `kubectl get nodes`


---
# KubeZero
All configs and scriptss are normally under:  
`kubezero/clusters/<ENV>/<REGION>`

## Prepare Config
check values.yaml for your cluster

## Get CloudBender kubezero config
Cloudbender creates a kubezero config file, which incl. all outputs from the Cloudformation stacks in `outputs/kube/kubezero.yaml`.  
Place kubezero.yaml *next* to the values.yaml

## Bootstrap
The first step will install all CRDs of enabled components only to prevent any dependency issues during the actual install.  
`./bootstrap.sh crds all clusters/<ENV>/<REGION>`

The second step will install all enabled components incl. various checks along the way.  
`./bootstrap.sh deploy all clusters/<ENV>/<REGION>`

## Success !  
Access your brand new container platform via kubectl / k9s / lens or the tool of your choosing.
