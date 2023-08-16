## Security - Todo
- https://github.com/freach/kubernetes-security-best-practice
- https://github.com/aquasecurity/kube-bench
- https://kubernetes.io/docs/tasks/debug-application-cluster/audit/
- https://kubernetes.io/docs/tasks/debug-application-cluster/falco/

## DNS - Todo
- https://github.com/kubernetes-sigs/external-dns/blob/0ef226f77ef80158257e1fe9705c095452a51545/docs/tutorials/istio.md

## Performance - Todo
- https://kubernetes.io/docs/tasks/administer-cluster/limit-storage-consumption/

- Set priorityclasses and proper CPU/MEM limits for core pods like api-server etc. as we host additional services on the master nodes which might affect these critical systems
  see: https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/

## Storage - Todo
- OpenSource S3 - https://min.io/
- LinStore - DRDB for K8s - https://vitobotta.com/2020/01/04/linstor-storage-the-kubernetes-way/, https://github.com/kvaps/kube-linstor, https://github.com/piraeusdatastore/piraeus
- ChubaoFS - CephFS competitor

# Monitoring
- https://github.com/cloudworkz/kube-eagle

## Cleanup - Todo
Something along the lines of https://github.com/onfido/k8s-cleanup which doesnt work as is

## Resources
- https://docs.google.com/spreadsheets/d/1WPHt0gsb7adVzY3eviMK2W8LejV0I5m_Zpc8tMzl_2w/edit#gid=0
- https://github.com/ishantanu/awesome-kubectl-plugins
- https://github.com/kubernetes/kubernetes/blob/master/cluster/gce/gci/configure-helper.sh

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
