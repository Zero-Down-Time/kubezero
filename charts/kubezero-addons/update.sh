#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

patch_chart aws-node-termination-handler
patch_chart aws-eks-asg-rolling-update-handler

update_docs
