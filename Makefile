REGISTRY := public.ecr.aws/zero-downtime
IMAGE := kubezero-admin
REGION := us-east-1

# Use KubeZero chart version rather than git tag for admin image
GIT_TAG = v$(shell yq .version < charts/kubezero/Chart.yaml)

# Also tag as Kubernetes major version
EXTRA_TAGS = $(shell echo $(GIT_TAG) | awk -F '.' '{ print $$1 "." $$2 }')

include .ci/podman.mk

update-charts:
	./scripts/update_helm.sh

update-chart-docs:
	for c in charts/*; do \
		[[ $$c =~ "kubezero-lib" ]] && continue ; \
		[[ $$c =~ "kubeadm" ]] && continue ; \
		helm-docs --skip-version-footer -c $$c ; \
	done

publish-charts:
	./scripts/publish.sh

