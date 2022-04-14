# KubeZero 1.22

## What's new - Major themes

### Alpine - Custom AMIs
Starting with 1.22, all KubeZero nodes will boot from custom pre-baked AMIs. These AMIs will be provided and shared by the Zero Down Time for all customers. All sources and the build pipeline are freely [available](https://git.zero-downtime.net/ZeroDownTime/alpine-zdt-images) as usual though.

This eliminates *ALL* dependencies at boot time other than container registries. Gone are the days when Ubuntu, SuSE or Github decided to ruin your morning coffee.  

KubeZero also migrates from Ubuntu 20.04 LTS to [Alpine v3.15](https://www.alpinelinux.org/releases/) as its base OS, which reduces the root file system size from 8GB to 2GB.  
Additionally all AMIs are encrypted, which is ensures encryption at rest even for every instance's root file system. This closes the last gaps in achieving *full encryption at rest* for every volume within a default KubeZero deployment. 

### Etcd
On AWS a new dedicated EBS volume will be provisioned per controller and used as persistent etcd storage. These volumes will persist for the life time of the cluster and reused by future controller nodes in each AZ.  
This ensure no data loss during upgrade or fail-overs of single controller clusters. The hourly backup on S3 will still be used as fallback in case the file system gets corrupted etc.  

As these volumes are `GP3` they provide higher and dedicated IOPS for etcd as well.

### DNS
The [external-dns](https://github.com/kubernetes-sigs/external-dns) controller got integrated and is used to provide DNS based loadbalacing for the apiserver itself. This allows high available control planes on AWS as well as bare-metal in combination with various DNS providers.  

Further usage of this controller to automate any DNS related configurations, like Ingress etc. is planned for following releases.

### Container runtime
Cri-o now uses crun rather than runc, which reduces the memory overhead *per pod* from 16M to 4M, details at [crun intro](https://www.redhat.com/sysadmin/introduction-crun)

## Version upgrades
- Istio to 1.13.2 using new upstream Helm charts
- aws-termination-handler to 1.16
- aws-iam-authenticator to 0.5.7, required for >1.22 allows using the latest version on the client side again 

## Misc
- new metrics and dashboards for openEBS LVM CSI drivers
- new node label `node.kubernetes.io/instance-type` for all nodes containing the EC2 instance type
- kubelet root moved to `/var/lib/containers` to ensure ephemeral storage is allocated from the configurable volume rather than the root fs of the worker


# Upgrade
`(No, really, you MUST read this before you upgrade)`

- Ensure your Kube context points to the correct cluster !
- Ensure any usage of Kiam has been migrated to OIDC providers as any remaining Kiam components will be deleted as part of the upgrade

1. Trigger the cluster upgrade:  
`./release/v1.22/upgrade_cluster.sh`

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

