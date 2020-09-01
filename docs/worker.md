# Operational guide for worker nodes

## Replace worker node
In order to change the instance type or in genernal replace worker nodes do:

* (optional) Update the launch configuration of the worker group

* Make sure there is enough capacity in the cluster to handle all pods being evicted for the node

* `kubectl drain --ignore-daemonsets node_name`  
will evict all pods except DaemonSets. In case there are pods with local storage review each affected pod. After being sure no important data will be lost add `--delete-local-data` to the original command above and try again.

* Terminate instance matching *node_name*

The new instance should take over the previous node_name assuming only node is being replaced at a time and automatically join and replace the previous node.
