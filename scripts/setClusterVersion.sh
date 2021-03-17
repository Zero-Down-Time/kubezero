#!/bin/bash

# Meant for testing only !!!

# This sets the Kubernetes Version in SSM
# Make sure your AWS Profile and Region points to the right direction ...

CONGLOMERATE=$1
VERSION=$2

aws ssm put-parameter --name /cloudbender/${CONGLOMERATE}/kubecontrol/meta/clusterversion --type SecureString --value "$(echo "$VERSION" | base64 -w0)" --overwrite

