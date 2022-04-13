#!/bin/bash -x

YAML=$1

# Convert keys
yq eval -i '
  .spec.source.targetRevision="1.22.8-2"
	' $YAML

# Extract values
yq eval '.spec.source.helm.values' $1 > _values.yaml


# merge _values.yaml back
yq eval -Pi '.spec.source.helm.values |= strload("_values.yaml")' $YAML

rm -f _values.yaml
