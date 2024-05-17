# Parse version from latest git semver tag
GIT_TAG ?= $(shell git describe --tags --match v*.*.* 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)

TAG ::= $(GIT_TAG)
# append branch name to tag if NOT main nor master
ifeq (,$(filter main master, $(GIT_BRANCH)))
	# If branch is substring of tag, omit branch name
	ifeq ($(findstring $(GIT_BRANCH), $(GIT_TAG)),)
		# only append branch name if not equal tag
		ifneq ($(GIT_TAG), $(GIT_BRANCH))
			# Sanitize GIT_BRANCH to allowed Docker tag character set
			TAG = $(GIT_TAG)-$(shell echo $$GIT_BRANCH | sed -e 's/[^a-zA-Z0-9]/-/g')
		endif
	endif
endif

ARCH ::= amd64
ALL_ARCHS ::= amd64 arm64
_ARCH = $(or $(filter $(ARCH),$(ALL_ARCHS)),$(error $$ARCH [$(ARCH)] must be exactly one of "$(ALL_ARCHS)"))

ifneq ($(TRIVY_REMOTE),)
	TRIVY_OPTS ::= --server $(TRIVY_REMOTE)
endif

.SILENT: ; # no need for @
.ONESHELL: ; # recipes execute in same shell
.NOTPARALLEL: ; # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
.PHONY: all # All targets are accessible for user
.DEFAULT: help # Running Make will run the help target

help: ## Show Help
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' .ci/podman.mk | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prepare:: ## custom step on the build agent before building

fmt:: ## auto format source

lint:: ## Lint source

build: ## Build the app
	buildah build --rm --layers -t $(IMAGE):$(TAG)-$(_ARCH) --build-arg TAG=$(TAG) --build-arg ARCH=$(_ARCH) --platform linux/$(_ARCH) .

test:: ## test built artificats

scan: ## Scan image using trivy
	echo "Scanning $(IMAGE):$(TAG)-$(_ARCH) using Trivy $(TRIVY_REMOTE)"
	trivy image $(TRIVY_OPTS) --quiet --no-progress localhost/$(IMAGE):$(TAG)-$(_ARCH)

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

rm-remote-untagged: ## delete all remote untagged and in-dev images, keep 10 tagged
	echo "Removing all untagged and in-dev images from $(IMAGE) in $(REGION)"
	.ci/ecr_public_lifecycle.py --repo $(IMAGE) --dev

clean:: ## clean up source folder

rm-image:
	test -z "$$(podman image ls -q $(IMAGE):$(TAG)-$(_ARCH))" || podman image rm -f $(IMAGE):$(TAG)-$(_ARCH) > /dev/null
	test -z "$$(podman image ls -q $(IMAGE):$(TAG)-$(_ARCH))" || echo "Error: Removing image failed"

## some useful tasks during development
ci-pull-upstream: ## pull latest shared .ci subtree
	git subtree pull --prefix .ci ssh://git@git.zero-downtime.net/ZeroDownTime/ci-tools-lib.git master --squash -m "Merge latest ci-tools-lib"

create-repo: ## create new AWS ECR public repository
	aws ecr-public create-repository --repository-name $(IMAGE) --region $(REGION)
