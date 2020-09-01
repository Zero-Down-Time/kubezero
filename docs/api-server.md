# api-server OAuth configuration

## Update Api-server config
Add the following extraArgs to the ClusterConfiguration configMap in the kube-system namespace:
`kubectl edit -n kube-system cm kubeadm-config`

```
        oidc-issuer-url: "https://accounts.google.com"
        oidc-client-id: "<CLIENT_ID from Google>"
        oidc-username-claim: "email"
        oidc-groups-claim: "groups"
```

## Resources
- https://kubernetes.io/docs/reference/access-authn-authz/authentication/
