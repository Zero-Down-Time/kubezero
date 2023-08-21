#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

login_ecr_public
update_helm

patch_chart aws-node-termination-handler
patch_chart aws-eks-asg-rolling-update-handler

update_docs
