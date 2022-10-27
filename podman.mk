# Parse version from latest git semver tag
GTAG=$(shell git describe --tags --match v*.*.* 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
TAG ?= $(shell echo $(GTAG) | awk -F '-' '{ print $$1 "-" $$2 }' | sed -e 's/-$$//')
ARCH := amd64

# EXTRA_TAGS supposed to be set at the caller, eg. $(shell echo $(TAG) | awk -F '.' '{ print $$1 "." $$2 }')

ifneq ($(TRIVY_REMOTE),)
  TRIVY_OPTS := --server $(TRIVY_REMOTE)
endif

.SILENT: ; # no need for @
.ONESHELL: ; # recipes execute in same shell
.NOTPARALLEL: ; # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
.PHONY: all # All targets are accessible for user
.DEFAULT: help # Running Make will run the help target

help: ## Show Help
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' .ci/podman.mk | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the app
	docker build --rm -t $(REGISTRY)/$(IMAGE):$(TAG)-$(ARCH) --build-arg TAG=$(TAG) --build-arg ARCH=$(ARCH) --platform linux/$(ARCH) .

test: rm-test-image ## Execute Dockerfile.test
	test -f Dockerfile.test && \
		{ docker build --rm -t $(REGISTRY)/$(IMAGE):$(TAG)-test --from=$(REGISTRY)/$(IMAGE):$(TAG) -f Dockerfile.test --platform linux/$(ARCH) . && \
			docker run --rm --env-host -t $(REGISTRY)/$(IMAGE):$(TAG)-$(ARCH)-test; } || \
		echo "No Dockerfile.test found, skipping test"

scan: ## Scan image using trivy
	echo "Scanning $(REGISTRY)/$(IMAGE):$(TAG)-$(ARCH) using Trivy $(TRIVY_REMOTE)"
	trivy image $(TRIVY_OPTS) $(REGISTRY)/$(IMAGE):$(TAG)-$(ARCH)

# We create new manifest and add TAG-ARCH image
# if manigest exists already, get it and add TAG-ARCH to eg. add arm64 to existing amd64
push: ## push images to registry
	for t in $(TAG) latest $(EXTRA_TAGS); \
		do echo "creating and pushing: $$t"; \
		docker tag $(REGISTRY)/$(IMAGE):$(TAG)-$(ARCH) $(REGISTRY)/$(IMAGE):$${t}-$(ARCH) && \
		docker push $(REGISTRY)/$(IMAGE):$${t}-$(ARCH); \
		podman manifest exists $(IMAGE):$$t || podman manifest create $(IMAGE):$$t; \
		buildah manifest add $(IMAGE):$$t $(REGISTRY)/$(IMAGE):$(TAG)-$(ARCH) && docker manifest push $(IMAGE):$$t $(REGISTRY)/$(IMAGE):$$t; \
	done

ecr-login: ## log into AWS ECR public
	aws ecr-public get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(REGISTRY)

clean: rm-test-image rm-image ## delete local built container and test images

rm-remote-untagged: ## delete all remote untagged images
	echo "Removing all untagged images from $(IMAGE) in $(REGION)"
	IMAGE_IDS=$$(for image in $$(aws ecr-public describe-images --repository-name $(IMAGE) --region $(REGION) --output json | jq -r '.imageDetails[] | select(.imageTags | not ).imageDigest'); do echo -n "imageDigest=$$image "; done) ; \
	  [ -n "$$IMAGE_IDS" ] && aws ecr-public batch-delete-image --repository-name $(IMAGE) --region $(REGION) --image-ids $$IMAGE_IDS || echo "No image to remove"

rm-image:
	test -z "$$(docker image ls -q $(IMAGE):$(TAG)-$(ARCH))" || docker image rm -f $(IMAGE):$(TAG)-$(ARCH) > /dev/null
	test -z "$$(docker image ls -q $(IMAGE):$(TAG)-$(ARCH))" || echo "Error: Removing image failed"

# Ensure we run the tests by removing any previous runs
rm-test-image:
	test -z "$$(docker image ls -q $(IMAGE):$(TAG)-$(ARCH)-test)" || docker image rm -f $(IMAGE):$(TAG)-$(ARCH)-test > /dev/null
	test -z "$$(docker image ls -q $(IMAGE):$(TAG)-$(ARCH)-test)" || echo "Error: Removing test image failed"

ci-pull-upstream: ## pull latest shared .ci subtree
	git stash && git subtree pull --prefix .ci ssh://git@git.zero-downtime.net/ZeroDownTime/ci-tools-lib.git master --squash && git stash pop

create-repo: ## create new AWS ECR public repository
	aws ecr-public create-repository --repository-name $(IMAGE) --region $(REGION)
