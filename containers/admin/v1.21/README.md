*Ensure your Kube context points to the correct cluster !!!*

1. Trigger the cluster upgrade:  
`./upgrade_121.sh`

2. Upgrade CFN stacks for the control plane and all worker groups
Change Kubernetes version in controller config from `1.20.X` to `1.21.9`

3. Reboot controller(s) one by one
Wait each time for controller to join and all pods running.
Might take a while ...

4. Patch current deployments, blocking ArgoCD otherwise  
`./kubezero_121.sh`

5. Migrate ArgoCD config for the cluster  
`./migrate_argo.sh <cluster/env/kubezero/application.yaml>`  
Adjust as needed, eg. ensure eck-operator is enabled if needed.  
git add / commit / push  
Watch ArgoCD do its work.

6. Replace worker nodes
Eg. by doubling `desired` for each worker ASG,  
once all new workers joined, drain old workers one by one,  
finally reset `desired` for each worker ASG which will terminate the old workers.

## Known issues
On old/current workers, until workers get replaced:

If pods seem stuck, eg. fluent-bit shows NotReady *after* control nodes have been upgraded  
  -> restart `kube-proxy` on the affected workers
