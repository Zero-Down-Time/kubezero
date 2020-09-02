## Security - Todo
- https://github.com/freach/kubernetes-security-best-practice
- https://github.com/aquasecurity/kube-bench
- https://kubernetes.io/docs/tasks/debug-application-cluster/audit/
- https://kubernetes.io/docs/tasks/debug-application-cluster/falco/

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
