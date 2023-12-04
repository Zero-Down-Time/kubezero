# KubeZero - Cluster upgrade

`(No, really, you MUST read this before you upgrade)`

Ensure your Kube context points to the correct cluster !

1. Review CFN config for controller and workers, no mandatory changes during this release though

2. Upgrade CFN stacks for the control plane *ONLY* !
  Updating the workers CFN stacks would trigger rolling updates right away !

3. Trigger cluster upgrade:  
  `./admin/upgrade_cluster.sh <path to the argocd app kubezero yaml for THIS cluster>`

4. Review the kubezero-config and if all looks good commit the ArgoApp resouce for Kubezero via regular git  
  git add / commit / push `<cluster/env/kubezero/application.yaml>`  

5. Reboot controller(s) one by one  
Wait each time for controller to join and all pods running.
Might take a while ...

6. Upgrade CFN stacks for the workers.  
  This in turn will trigger automated worker updates by evicting pods and launching new workers in a rolling fashion.
  Grab a coffee and keep an eye on the cluster to be safe ...
  Depending on your cluster size it might take a while to roll over all workers!

7. Re-enable ArgoCD by hitting <return> on the still waiting upgrade script 

8. Head to the ArgoCD UI and sync all KubeZero apps to verify all are synced successfully.
