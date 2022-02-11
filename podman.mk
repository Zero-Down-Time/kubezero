# Parse version from latest git semver tag
GTAG=$(shell git describe --tags --match v*.*.* 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
TAG ?= $(shell echo $(GTAG) | awk -F '-' '{ print $$1 "-" $$2 }' | sed -e 's/-$$//')

ifeq ($(TRIVY_REMOTE),)
  TRIVY_OPTS := image
else
  TRIVY_OPTS := client --remote ${TRIVY_REMOTE}
endif

.PHONY: build test scan push clean

all: test


build:
	@docker image exists $(IMAGE):$(TAG) || \
		docker build --rm -t $(IMAGE):$(TAG) --build-arg TAG=$(TAG) .

test: build rm-test-image
	@test -f Dockerfile.test && \
		docker build --rm -t $(IMAGE):$(TAG)-test --from=$(IMAGE):$(TAG) -f Dockerfile.test . || \
		echo "No Dockerfile.test found, skipping test"

scan: build
	@echo "Scanning $(IMAGE):$(TAG) using Trivy"
	@trivy $(TRIVY_OPTS) $(IMAGE):$(TAG)

push: scan
	@aws ecr-public get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(REGISTRY)
	@docker tag $(IMAGE):$(TAG) $(REGISTRY)/$(IMAGE):$(TAG) $(REGISTRY)/$(IMAGE):latest
	docker push $(REGISTRY)/$(IMAGE):$(TAG)
	docker push $(REGISTRY)/$(IMAGE):latest

clean: rm-test-image rm-image

# Delete all untagged images
.PHONY: rm-remote-untagged
rm-remote-untagged:
	@echo "Removing all untagged images from $(IMAGE) in $(REGION)"
	@aws ecr-public batch-delete-image --repository-name $(IMAGE) --region $(REGION) --image-ids $$(for image in $$(aws ecr-public describe-images --repository-name $(IMAGE) --region $(REGION) --output json | jq -r '.imageDetails[] | select(.imageTags | not ).imageDigest'); do echo -n "imageDigest=$$image "; done)

.PHONY: rm-image
rm-image:
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG))" || docker image rm -f $(IMAGE):$(TAG) > /dev/null
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG))" || echo "Error: Removing image failed"

# Ensure we run the tests by removing any previous runs
.PHONY: rm-test-image
rm-test-image:
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG)-test)" || docker image rm -f $(IMAGE):$(TAG)-test > /dev/null
	@test -z "$$(docker image ls -q $(IMAGE):$(TAG)-test)" || echo "Error: Removing test image failed"

.DEFAULT:
	@echo "$@ not implemented. NOOP"
