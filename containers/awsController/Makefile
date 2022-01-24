SHELL_OPERATOR_VERSION ?= 1.0.6
REGISTRY := public.ecr.aws/zero-downtime
REPOSITORY := kubezero-controller
TAG := $(REPOSITORY):v$(SHELL_OPERATOR_VERSION)-aws

.PHONY: build push clean scan

all: build push

build:
	podman build --rm --squash-all --build-arg SHELL_OPERATOR_VERSION=$(SHELL_OPERATOR_VERSION) -t $(TAG) .

push:
	aws ecr-public get-login-password --region us-east-1 | podman login --username AWS --password-stdin $(REGISTRY)
	podman tag $(TAG) $(REGISTRY)/$(TAG)
	podman push $(REGISTRY)/$(TAG)

clean:
	podman image prune -f

scan:
	podman system service&
	sleep 5; trivy $(TAG)
