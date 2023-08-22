#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

export ISTIO_VERSION=$(yq eval '.dependencies[] | select(.name=="gateway") | .version' Chart.yaml)

patch_chart gateway
