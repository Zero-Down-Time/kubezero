# Quickstart    
---

# CloudBender

## Prepare Config
- check config/kube/kube-control-plane.yaml
- check config/kube/kube-workers.yaml


## Deploy Control Plane
- cloudbender sync kube-control-plane

## Get kubectl config
- get admin.conf from S3 and store in your local `~/.kube` folder

## Verify controller nodes
- Verify all controller nodes have the expected version and are *Ready*, eg via: `kubectl get nodes`

## Deploy Worker group
- cloudbender sync kube-workers

## Verify all nodes
- Verify all nodes incl. workers have the expected version and are *Ready*, eg via: `kubectl get nodes`


---
# KubeZero 

## Prepare Config
- check values.yaml

Easiest way to get the ARNs for various IAM roles is to use the CloudBender output command:  
```cloudbender outputs config/kube-control-plane.yaml```

## Deploy KubeZero Helm chart
`./deploy.sh`


## Verify ArgoCD
At this stage we there is no support for any kind of Ingress yet. To reach the Argo API port forward from localhost via:  
`kubectl port-forward svc/kubezero-argocd-server -n argocd 8080:443`

Next download the argo-cd cli, details for different OS see https://argoproj.github.io/argo-cd/cli_installation/  

Finally login into argo-cd via `argocd login localhost:8080` using the *admin* user and the password set in values.yaml earlier.

List all Argo applications via: `argocd app list`.  
Currently it is very likely that you need to manually trigger sync runs for `cert-manager`as well as `kiam`.  
eg. `argocd app cert-manager sync`


# Demo / own apps
- Add your own application to ArgoCD via the cli