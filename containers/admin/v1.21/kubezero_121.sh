#!/bin/bash
set -x

# Allow EFS and EBS Argo apps to be deleted without removing things like storageClasses etc.
# to be replaced by kubezero-storage
kubectl patch application aws-ebs-csi-driver -n argocd  --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
kubectl patch application aws-efs-csi-driver -n argocd  --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'

# Delete EBS and EFS Deployments and Daemonsets as we cannot change the lables while moving them to storage.
# This will NOT affect provisioned volumes
kubectl delete deployment ebs-csi-controller -n kube-system
kubectl delete daemonSet ebs-csi-node -n kube-system
kubectl delete statefulset ebs-snapshot-controller -n kube-system

kubectl delete deployment efs-csi-controller -n kube-system
kubectl delete daemonSet efs-csi-node -n kube-system
