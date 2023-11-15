#!/bin/bash
set -ex

. ../../scripts/lib-update.sh

#login_ecr_public
update_helm

# update falco rules
wget -qO files/rules/k8s_audit_rules.yaml https://raw.githubusercontent.com/falcosecurity/plugins/master/plugins/k8saudit/rules/k8s_audit_rules.yaml

update_docs
