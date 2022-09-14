# Cluster upgrade flow

## During 1.23 upgrade
- create new kubezero-values CM if not exists yet, by merging parts of the legacy /etc/kubernetes/kubeadm-values.yaml values with potentially existing values from kubezero ArgoCD app values


# General flow

- No ArgoCD -> user kubezero-values CM
- ArgoCD -> update kubezero-values CM with current values from ArgoCD app values

- Apply any upgrades / migrations
