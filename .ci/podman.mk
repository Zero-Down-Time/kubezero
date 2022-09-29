# Parse version from latest git semver tag
GTAG=$(shell git describe --tags --match v*.*.* 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
TAG ?= $(shell echo $(GTAG) | awk -F '-' '{ print $$1 "-" $$2 }' | sed -e 's/-$$//')

# EXTRA_TAGS supposed to be set at the caller, eg. $(shell echo $(TAG) | awk -F '.' '{ print $$1 "." $$2 }')

ifneq ($(TRIVY_REMOTE),)
  TRIVY_OPTS := --server ${TRIVY_REMOTE}
endif

.PHONY: build test scan push clean

all: test

build:
	@docker image exists $(REGISTRY)/$(IMAGE):$(TAG) || \
		docker build --rm -t $(REGISTRY)/$(IMAGE):$(TAG) --build-arg TAG=$(TAG) .

test: build rm-test-image
	@test -f Dockerfile.test && \
		{ docker build --rm -t $(REGISTRY)/$(IMAGE):$(TAG)-test --from=$(REGISTRY)/$(IMAGE):$(TAG) -f Dockerfile.test . && \
			docker run --rm --env-host -t $(REGISTRY)/$(IMAGE):$(TAG)-test; } || \
		echo "No Dockerfile.test found, skipping test"

scan: build
	@echo "Scanning $(REGISTRY)/$(IMAGE):$(TAG) using Trivy"
	@trivy image $(TRIVY_OPTS) $(REGISTRY)/$(IMAGE):$(TAG)

push: ecr-login build
	@for t in $(TAG) latest $(EXTRA_TAGS); do echo "tag and push: $$t"; docker tag $(IMAGE):$(TAG) $(REGISTRY)/$(IMAGE):$$t && docker push $(REGISTRY)/$(IMAGE):$$t; done

ecr-login:
	@aws ecr-public get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(REGISTRY)

clean: rm-test-image rm-image

# Delete all untagged images
.PHONY: rm-remote-untagged
rm-remote-untagged:
	@echo "Removing all untagged images from $(IMAGE) in $(REGION)"
	@IMAGE_IDS=$$(for image in $$(aws ecr-public describe-images --repository-name $(IMAGE) --region $(REGION) --output json | jq -r '.imageDetails[] | select(.imageTags | not ).imageDigest'); do echo -n "imageDigest=$$image "; done) ; \
	  [ -n "$$IMAGE_IDS" ] && aws ecr-public batch-delete-image --repository-name $(IMAGE) --region $(REGION) --image-ids $$IMAGE_IDS || echo "Nothing to remove"

.PHONY: rm-image
rm-image:
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG))" || docker image rm -f $(IMAGE):$(TAG) > /dev/null
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG))" || echo "Error: Removing image failed"

# Ensure we run the tests by removing any previous runs
.PHONY: rm-test-image
rm-test-image:
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG)-test)" || docker image rm -f $(IMAGE):$(TAG)-test > /dev/null
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG)-test)" || echo "Error: Removing test image failed"

# Convience task during dev of downstream projects
.PHONY: ci-pull-upstream
ci-pull-upstream:
	git stash && git subtree pull --prefix .ci ssh://git@git.zero-downtime.net/ZeroDownTime/ci-tools-lib.git master --squash && git stash pop

.PHONY: create-repo
create-repo:
	aws ecr-public create-repository --repository-name $(IMAGE) --region $(REGION)

.DEFAULT:
	@echo "$@ not implemented. NOOP"
