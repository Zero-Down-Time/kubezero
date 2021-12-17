VERSION ?= 1.21.8
ALPINE_VERSION ?= 3.15
REGISTRY := public.ecr.aws/zero-downtime
REPOSITORY := kubezero-admin
TAG := $(REPOSITORY):v$(VERSION)
KUBE_VERSION := $(shell echo $(VERSION) | sed -e 's/\.[[:digit:]]*$$//')

.PHONY: build push clean scan

all: build push

build:
	podman build --rm --squash-all --build-arg KUBE_VERSION=$(KUBE_VERSION) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) -t $(TAG) .

push:
	aws ecr-public get-login-password --region us-east-1 | podman login --username AWS --password-stdin $(REGISTRY)
	podman tag $(TAG) $(REGISTRY)/$(TAG)
	podman push $(REGISTRY)/$(TAG)

clean:
	podman image prune -f

scan:
	podman system service& 
	sleep 5; trivy $(TAG)
