#!/bin/bash

# We only need to delete the service monitor and virtual service, others will be taken over by the new chart and we dont loose data
kubectl delete -n logging VirtualService kibana-logging
kubectl delete -n logging ServiceMonitor es-logging
