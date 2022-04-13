---
title: KubeZero 1.22
---

# Release notes

## Custom AMIs
Starting with 1.22.X, all KubeZero nodes will boot from custom pre-baked AMIs. These AMIs will be provided and shared by the Zero Down Time AWS account.  
This change elimitates *ALL* dependencies at boot time other than container registries. Gone are the days when Ubuntu, SuSE or Github decided to ruin your morning coffee.  

While we are at it, KubeZero also moves from Ubuntu 20.04LTS to Alpine 3.15 as its base OS.

## Misc
- new node label `node.kubernetes.io/instance-type` for all nodes containing the EC2 instance type
- container runtime migrated from runc to crun, reduces memory overhead per pod from 16M to 4M, more info: https://www.redhat.com/sysadmin/introduction-crun


## Upgrade

*Ensure your Kube context points to the correct cluster !!!*

1. Trigger the cluster upgrade:  
`./upgrade_122.sh`

2. Upgrade CFN stacks for the control plane and all worker groups
Change Kubernetes version in controller config from `1.21.9` to `1.22.8`

3. Reboot controller(s) one by one
Wait each time for controller to join and all pods running.
Might take a while ...

4. Migrate ArgoCD config for the cluster  
`./migrate_argo.sh <cluster/env/kubezero/application.yaml>`  
Adjust as needed, eg. ensure eck-operator is enabled if needed.  
git add / commit / push  
Watch ArgoCD do its work.

5. Replace worker nodes
Eg. by doubling `desired` for each worker ASG,  
once all new workers joined, drain old workers one by one,  
finally reset `desired` for each worker ASG which will terminate the old workers.

## Known issues

