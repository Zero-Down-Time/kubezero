# KubeZero 1.22

## What's new - Major themes

### Alpine - Custom AMIs
Starting with 1.22, all KubeZero nodes boot using custom AMIs. These AMIs will be provided and shared by the Zero Down Time for all customers. As always, all sources incl. the build pipeline are freely available [here](https://git.zero-downtime.net/ZeroDownTime/alpine-zdt-images).

This eliminates *ALL* dependencies at boot time other than container registries. Gone are the days when Ubuntu, SuSE or Github decided to ruin your morning coffee.  

KubeZero migrates from Ubuntu 20.04 LTS to [Alpine v3.15](https://www.alpinelinux.org/releases/) as its base OS.  
#### Highlights:
- minimal attack surface by removing all unnecessary bloat,  
like all things SystemD, Ubuntu's snap, etc
- reduced root file system size from 8GB to 2GB
- minimal memory consumption of about 12MB fully booted

  *Minimal* fully booted instance incl. SSH and Monit:

  | | Ubuntu | Alpine|
  |-|--------|-----|
  | Memory used | 60MB | 12 MB |
  | RootFS used | 1.1GB | 330 MB |
  | RootFS encrypted | no | yes |
  | Kernel | 5.11 | 5.15 |
  | Init | Systemd | OpenRC |
  | AMI / EBS size | 8GB | 1GB |
  | Boot time | ~120s | ~45s |

- Encrypted AMIs:  
This closes the last gaps you might have in achieving *full encryption at rest* for every volume within a default KubeZero deployment. 

### Etcd
On AWS a new dedicated GP3 EBS volume gets provisioned per controller and is used as persistent etcd storage. These volumes will persist for the life time of the cluster and reused by future controller nodes in each AZ.  
This ensure no data loss during upgrade or restore situations of single controller clusters. The hourly backup on S3 will still be used as fallback / disaster recovery option in case the file system gets corrupted etc.  


### DNS
The [external-dns](https://github.com/kubernetes-sigs/external-dns) controller got integrated and is used to provide DNS based loadbalacing for the apiserver itself. This allows high available control planes on AWS as well as bare-metal in combination with various DNS providers.  

Further usage of this controller to automate any DNS related configurations, like Ingress etc. is planned for following releases.

### Container runtime
Cri-o now uses crun rather than runc, which reduces the memory overhead *per pod* from 16M to 4M, details at [crun intro](https://www.redhat.com/sysadmin/introduction-crun)  

With 1.22 and the switch to crun, support for [CgroupV2](https://www.kernel.org/doc/Documentation/cgroup-v2.txt) has been enabled.

### AWS Neuron INF support
Initial support for [Inf1 instances](https://aws.amazon.com/ec2/instance-types/inf1/) part of [AWS Neuron](https://aws.amazon.com/machine-learning/neuron/).  

Workers automatically load the custom kernel module on these instance types and expose the `/dev/neuron*` devices.

## Version upgrades
- Istio to 1.13.3 using the new Helm [gateway charts](https://istio.io/latest/docs/setup/additional-setup/gateway/)
- Logging: ECK operator upgraded from 1.6 to 2.1, fluent-bit 1.9.3
- Metrics: Prometheus and all Grafana charts to latest to match V1.22
- ArgoCD to V2.3
- AWS EBS/EFS CSI drivers to latest versions
- cert-manager to V1.8
- aws-termination-handler to 1.16
- aws-iam-authenticator to 0.5.7, required for >1.22 which allows using the latest version on the client side again

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

4. Migrate ArgoCD KubeZero config for your cluster:  
```cat <cluster/env/kubezero/application.yaml> | ./release/v1.22/migrate_agro.py```  
Adjust as needed...  

- git add / commit / push  
- Watch ArgoCD do its work.

5. Replace worker nodes
Eg. by doubling `desired` for each worker ASG,  
once all new workers joined, drain old workers one by one,  
finally reset `desired` for each worker ASG which will terminate the old workers.

## Known issues

### Metrics
- `metrics-prometheus-node-exporter` will go into `CreateContainerError`
on 1.21 nodes until the metrics module is upgraded, due to underlying OS changes

### Logging
- `logging-fluent-bit` will go into `CrashLoopBackoff` on 1.21 nodes, until logging module is upgraded, due to underlying OS changes