#!/bin/bash

ns=$(kubectl get ns -l argocd.argoproj.io/instance | grep -v NAME | awk '{print $1}')

for n in $ns; do
  kubectl label --overwrite namespace $n 'argocd.argoproj.io/instance-'
done
