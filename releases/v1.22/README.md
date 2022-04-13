# KubeZero 1.22

## Release notes

### Custom AMIs
Starting with 1.22, all KubeZero nodes will boot from custom pre-baked AMIs. These AMIs will be provided and shared by the Zero Down Time for all customers, all sources and build pipeline are freely [available](https://git.zero-downtime.net/ZeroDownTime/alpine-zdt-images).

This eliminates *ALL* dependencies at boot time other than container registries. Gone are the days when Ubuntu, SuSE or Github decided to ruin your morning coffee.  

KubeZero also migrates from Ubuntu 20.04 LTS to [Alpine v3.15](https://www.alpinelinux.org/releases/) as its base OS, which reduces the root file system size from 8GB to 2GB.  
Additionally all AMIs are encrypted, which is ensures encryption at rest even for every instance's root file system. This closes the last gaps in achieving *full encryption at rest* for every volume within a default KubeZero deployment. 

### DNS
The [external-dns](https://github.com/kubernetes-sigs/external-dns) controller got integrated and is used to provide DNS based loadbalacing for the apiserver itself. This allows high available control planes on AWS as well as bare-metal in combination with various DNS providers.  

Further usage of this controller to automate any DNS related configurations, like Ingress etc. is planned for following releases.

### crun - container runtime
got migrated from runc to crun, which reduces the memory overhead *per pod* from 16M to 4M, details at [crun intro](https://www.redhat.com/sysadmin/introduction-crun)

### Version upgrades
- Istio to 1.13.2
- aws-termination-handler to 1.16
- aws-iam-authenticator to 0.5.7

### Misc
- new metrics and dashboards for openEBS LVM CSI drivers
- new node label `node.kubernetes.io/instance-type` for all nodes containing the EC2 instance type


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

