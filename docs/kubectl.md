# kubectl
kubectl is the basic cmdline tool to interact with any kubernetes cluster via the kube-api server.

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
