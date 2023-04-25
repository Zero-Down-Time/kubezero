# Parse version from latest git semver tag
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
GIT_TAG := $(shell git describe --tags --match v*.*.* 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

# append branch name to tag if NOT main nor master
TAG := $(GIT_TAG)
ifeq (,$(filter main master, $(GIT_BRANCH)))
	ifneq ($(GIT_TAG), $(GIT_BRANCH))
		TAG = $(GIT_TAG)-$(GIT_BRANCH)
	endif
endif

# optionally set by the caller
EXTRA_TAGS :=

ARCH := amd64
ALL_ARCHS := amd64 arm64
_ARCH = $(or $(filter $(ARCH),$(ALL_ARCHS)),$(error $$ARCH [$(ARCH)] must be exactly one of "$(ALL_ARCHS)"))

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
	buildah build --rm --layers -t $(IMAGE):$(TAG)-$(_ARCH) --build-arg TAG=$(TAG) --build-arg ARCH=$(_ARCH) --platform linux/$(_ARCH) .

test: rm-test-image ## Execute Dockerfile.test
	test -f Dockerfile.test && \
		{ buildah build --rm --layers -t $(REGISTRY)/$(IMAGE):$(TAG)-test --from=$(REGISTRY)/$(IMAGE):$(TAG) -f Dockerfile.test --platform linux/$(_ARCH) . && \
			podman run --rm --env-host -t $(REGISTRY)/$(IMAGE):$(TAG)-$(_ARCH)-test; } || \
		echo "No Dockerfile.test found, skipping test"

scan: ## Scan image using trivy
	echo "Scanning $(IMAGE):$(TAG)-$(_ARCH) using Trivy $(TRIVY_REMOTE)"
	trivy image $(TRIVY_OPTS) localhost/$(IMAGE):$(TAG)-$(_ARCH)

# first tag and push all actual images
# create new manifest for each tag and add all available TAG-ARCH before pushing
push: ecr-login ## push images to registry
	for t in $(TAG) latest $(EXTRA_TAGS); do \
		echo "Tagging image with $(REGISTRY)/$(IMAGE):$${t}-$(ARCH)"
		buildah tag $(IMAGE):$(TAG)-$(_ARCH) $(REGISTRY)/$(IMAGE):$${t}-$(_ARCH); \
		buildah manifest rm $(IMAGE):$$t || true; \
		buildah manifest create $(IMAGE):$$t; \
		for a in $(ALL_ARCHS); do \
			buildah manifest add $(IMAGE):$$t $(REGISTRY)/$(IMAGE):$(TAG)-$$a; \
		done; \
		echo "Pushing manifest $(IMAGE):$$t"
		buildah manifest push --all $(IMAGE):$$t docker://$(REGISTRY)/$(IMAGE):$$t; \
	done

ecr-login: ## log into AWS ECR public
	aws ecr-public get-login-password --region $(REGION) | podman login --username AWS --password-stdin $(REGISTRY)

clean: rm-test-image rm-image ## delete local built container and test images

rm-remote-untagged: ## delete all remote untagged images
	echo "Removing all untagged images from $(IMAGE) in $(REGION)"
	IMAGE_IDS=$$(for image in $$(aws ecr-public describe-images --repository-name $(IMAGE) --region $(REGION) --output json | jq -r '.imageDetails[] | select(.imageTags | not ).imageDigest'); do echo -n "imageDigest=$$image "; done) ; \
		[ -n "$$IMAGE_IDS" ] && aws ecr-public batch-delete-image --repository-name $(IMAGE) --region $(REGION) --image-ids $$IMAGE_IDS || echo "No image to remove"

rm-image:
	test -z "$$(podman image ls -q $(IMAGE):$(TAG)-$(_ARCH))" || podman image rm -f $(IMAGE):$(TAG)-$(_ARCH) > /dev/null
	test -z "$$(podman image ls -q $(IMAGE):$(TAG)-$(_ARCH))" || echo "Error: Removing image failed"

# Ensure we run the tests by removing any previous runs
rm-test-image:
	test -z "$$(podman image ls -q $(IMAGE):$(TAG)-$(_ARCH)-test)" || podman image rm -f $(IMAGE):$(TAG)-$(_ARCH)-test > /dev/null
	test -z "$$(podman image ls -q $(IMAGE):$(TAG)-$(_ARCH)-test)" || echo "Error: Removing test image failed"

ci-pull-upstream: ## pull latest shared .ci subtree
	git stash && git subtree pull --prefix .ci ssh://git@git.zero-downtime.net/ZeroDownTime/ci-tools-lib.git master --squash && git stash pop

create-repo: ## create new AWS ECR public repository
	aws ecr-public create-repository --repository-name $(IMAGE) --region $(REGION)
