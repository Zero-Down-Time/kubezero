- upgrade single control plane to latest
- change CFN for control plabe to HA and deploy
  This will launch controllers in AZ2 and AZ3 joining the party
- change the HA flag in kubezero-values CM
- update KubeZero either via cli or ArgoCD
