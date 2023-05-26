REGISTRY := public.ecr.aws/zero-downtime
IMAGE := kubezero-admin
REGION := us-east-1

# Also tag as Kubernetes major version
MY_TAG = $(shell git describe --tags --match v*.*.* 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
EXTRA_TAGS = $(shell echo $(MY_TAG) | awk -F '.' '{ print $$1 "." $$2 }')

include .ci/podman.mk

update-charts:
	./scripts/update_helm.sh

update-chart-docs:
	for c in charts/*; do \
		[[ $$c =~ "kubezero-lib" ]] && continue ; \
		[[ $$c =~ "kubeadm" ]] && continue ; \
		helm-docs -c $$c ; \
	done

publish-charts:
	./scripts/publish.sh

