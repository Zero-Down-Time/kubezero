# Cluster Operations

## Delete evicted pods across all namespaces

`
kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | "kubectl delete pods \(.metadata.name) -n \(.metadata.namespace)"' | xargs -n 1 bash -c
`

## cleanup stuck namespace
`for ns in $(kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}'); do  kubectl get ns $ns -ojson | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -; done
`

## Cleanup old replicasets
`kubectl get rs --all-namespaces | awk {' if ($3 == 0 && $4 == 0) system("kubectl delete rs "$2" --namespace="$1)'}`

## Replace worker nodes
In order to change the instance type or in genernal replace worker nodes do:

* (optional) Update the launch configuration of the worker group

* Make sure there is enough capacity in the cluster to handle all pods being evicted for the node

* `kubectl drain --ignore-daemonsets node_name`  
will evict all pods except DaemonSets. In case there are pods with local storage review each affected pod.    
After being sure no important data will be lost add `--delete-local-data` to the original command above and try again.

* Terminate instance matching *node_name*

The new instance should take over the previous node_name assuming only node is being replaced at a time and automatically join and replace the previous node.

---

# kubectl
kubectl is the basic cmdline tool to interact with any kubernetes cluster via the kube-api server

## Plugins
As there are various very useful plugins for kubectl the first thing should be to install *krew* the plugin manager.  
See: https://github.com/kubernetes-sigs/krew for details

List of awesome plugins: https://github.com/ishantanu/awesome-kubectl-plugins

### kubelogin
To login / authenticate against an openID provider like Google install the kubelogin plugin.  
See: https://github.com/int128/kubelogin

Make sure to adjust your kubeconfig files accordingly !

### kauthproxy
Easiest way to access the Kubernetes dashboard, if installed in the targeted cluster, is to use the kauthproxy plugin.  
See: https://github.com/int128/kauthproxy  

Once installed simply execute:  
`kubectl auth-proxy -n kubernetes-dashboard https://kubernetes-dashboard.svc`  
and access the dashboard via the automatically opened browser window.


## Istio
HTTP Body size
- https://github.com/istio/istio/issues/26152

AccessLogs:
- https://dev.to/ironcore864/a-comprehensive-tutorial-on-service-mesh-istio-envoy-access-log-and-log-filtering-2j3i
