# Cluster upgrade flow

## Hard refresh
```kubectl annotate app/kubezero -n argocd argocd.argoproj.io/refresh="hard"
```

# General flow

- No ArgoCD -> user kubezero-values CM
- ArgoCD -> update kubezero-values CM with current values from ArgoCD app values

- Apply any upgrades / migrations
