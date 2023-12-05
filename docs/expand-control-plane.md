- upgrade single control plane to latest
- change CFN for control plabe to HA and deploy
  This will launch controllers in AZ2 and AZ3 joining the party
- change the HA flag in kubezero-values CM
- ensure ArgoCD is either disabled or ensure correct settings pushed to git etc.
- termitate the original controller and manually delete its etcd membership as the etcd name changes -> Might change that for next release ??
