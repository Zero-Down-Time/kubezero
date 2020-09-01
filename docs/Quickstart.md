# Quickstart    
---

# CloudBender

## Prepare Config
- check config/kube/kube-control-plane.yaml
- check config/kube/kube-workers.yaml

## Deploy Cluster
- cloudbender sync config/kube --multi  
  The latest versions now support waiting for the control plane to bootstrap allowing deployments in one step !

## Get kubectl config
- get admin.conf from S3 and store in your local `~/.kube` folder  
  S3 URL will also be in the Slack message after successful bootstrap !

## Verify nodes
- Verify all nodes have the expected version and are *Ready*, eg via: `kubectl get nodes`


---
# KubeZero
All configs and scriptss are normally under:  
`artifacts/<ENV>/<REGION>/kubezero`

## Prepare Config
check values.yaml for your cluster

## Get CloudBender kubezero config
Cloudbender creates a kubezero config file, which incl. all outputs from the Cloudformation stacks in `outputs/kube/kubezero.yaml`.  
- copy kubezero.yaml *next* to the values.yaml named as `cloudbender.yaml`.  

## Deploy KubeZero Helm chart
`./deploy.sh`

The deploy script will handle the initial bootstrap process as well as the roll out of advanced components like Prometheus, Istio and ElasticSearch/Kibana in various phases.

It will take about 10 to 15 minutes for ArgoCD to roll out all the services...


# Own apps
- Add your own application to ArgoCD via the cli

# Troubleshooting

## Verify ArgoCD
To reach the Argo API port forward from localhost via:  
`kubectl port-forward svc/kubezero-argocd-server -n argocd 8080:443`

Next download the argo-cd cli, details for different OS see https://argoproj.github.io/argo-cd/cli_installation/  

Finally login into argo-cd via `argocd login localhost:8080` using the *admin* user and the password set in values.yaml earlier.

List all Argo applications via: `argocd app list`.  


