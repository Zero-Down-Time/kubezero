# Cluster Operations

## Clean up
### Delete evicted pods across all namespaces

`kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | "kubectl delete pods \(.metadata.name) -n \(.metadata.namespace)"' | xargs -n 1 bash -c
`
### Cleanup old replicasets
`kubectl get rs --all-namespaces | awk {' if ($3 == 0 && $4 == 0) system("kubectl delete rs "$2" --namespace="$1)'}`
