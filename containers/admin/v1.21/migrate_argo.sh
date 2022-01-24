#!/bin/bash -x

YAML=$1

# Convert keys
yq eval -i '
  .spec.source.repoURL="https://cdn.zero-downtime.net/charts" |
  .spec.source.targetRevision="1.21.8-4" |
  del(.spec.source.helm.parameters)' $YAML

# Extract values
yq eval '.spec.source.helm.values' $1 > _values.yaml

# Remove kiam and calico from Argo
yq eval -i 'del(.calico) | del(.kiam)' _values.yaml

# Move storage into module
yq eval -i '.storage.enabled=true' _values.yaml

[ $(yq eval 'has("aws-ebs-csi-driver")' _values.yaml) == "true" ] && yq eval -i '.storage.aws-ebs-csi-driver=.aws-ebs-csi-driver' _values.yaml
[ $(yq eval 'has("aws-efs-csi-driver")' _values.yaml) == "true" ] && yq eval -i '.storage.aws-efs-csi-driver=.aws-efs-csi-driver' _values.yaml

# Finally remove old helm apps
yq eval -i 'del(.aws-ebs-csi-driver) | del(.aws-efs-csi-driver)' _values.yaml

# merge _values.yaml back
yq eval -Pi '.spec.source.helm.values |= strload("_values.yaml")' $YAML

rm -f _values.yaml
