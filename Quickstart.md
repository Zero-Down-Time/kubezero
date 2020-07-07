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

The deploy script will handle the initial bootstrap process up to point of installing advanced services like Istio or Prometheus.  
It will take about 10min to reach the point of being able to install these advanced services.

## Verify ArgoCD
At this stage we there is no support for any kind of Ingress yet. To reach the Argo API port forward from localhost via:  
`kubectl port-forward svc/kubezero-argocd-server -n argocd 8080:443`

Next download the argo-cd cli, details for different OS see https://argoproj.github.io/argo-cd/cli_installation/  

Finally login into argo-cd via `argocd login localhost:8080` using the *admin* user and the password set in values.yaml earlier.

List all Argo applications via: `argocd app list`.  
Currently it is very likely that you need to manually trigger sync runs for `cert-manager`as well as `kiam`.  
eg. `argocd app cert-manager sync`


# Only proceed any further if all Argo Applications show healthy !!

## WIP not yet integrated into KubeZero

### Istio
Istio is currently pinned to version 1.4.X as this is the last version supporting installation via helm charts. 

Until Istio is integrated into KubeZero as well as upgraded to 1.6 we have to install manually.  

- adjust values.yaml
- update domain in `ingress-certificate.yaml`
- update.sh
- deploy.sh

### Logging
To deploy fluentbit only required adjustment is the `fluentd_host=<LOG_HOST>` in the kustomization.yaml.

- deploy namespace for logging via deploy.sh
- deploy fluentbit via `kubectl apply -k fluentbit`

### Prometheus / Grafana
Only adjustment required is the ingress routing config in istio-service.yaml. Adjust as needed before executing:  
`deploy.sh`

### EFS CSI
- add the EFS fs-ID from the worker cloudformation output into values.yaml and the efs-pv.yaml
- `./deploy.sh`

# Demo / own apps
- Add your own application to ArgoCD via the cli