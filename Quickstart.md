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


---
# KubeZero 

## Prepare Config
- check values.yaml

## Deploy KubeZero Helm chart
`./deploy.sh`


## Verify ArgoCD
At this stage we there is no support for any kind of Ingress yet. Therefore in order to reach the Argo API you port forwarding.  
`kubectl port-forward svc/argocd-server -n argocd 8080:443`

Next we to download the argo-cd cli, see https://argoproj.github.io/argo-cd/cli_installation/  

Finally login into argo-cd via `argocd login localhost:8080` using the *admin* user and the password set in values.yaml earlier.

# Demo / own apps
- Add your own application to ArgoCD via the cli