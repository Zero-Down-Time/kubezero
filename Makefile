REGISTRY := public.ecr.aws/zero-downtime
IMAGE := kubezero-admin
REGION := us-east-1

# Also tag as Kubernetes major version
EXTRA_TAGS = $(shell echo $(TAG) | awk -F '.' '{ print $$1 "." $$2 }')

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

