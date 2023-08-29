#!/bin/bash
#set -eEx
#set -o pipefail
set -x

#VERSION="latest"
KUBE_VERSION="v1.26.8"
WORKDIR=$(mktemp -p /tmp -d kubezero.XXX)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/libhelm.sh
CHARTS="$(dirname $SCRIPT_DIR)/charts"

get_kubezero_values

# Always use embedded kubezero chart
helm template $CHARTS/kubezero -f $WORKDIR/kubezero-values.yaml --kube-version $KUBE_VERSION --version ~$KUBE_VERSION --devel --output-dir $WORKDIR

# CRDs first
_helm crds $1
_helm apply $1
