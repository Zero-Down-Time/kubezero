BUCKET ?= zero-downtime
BUCKET_PREFIX ?= /cloudbender/distfiles
FILES ?= distfiles.txt

.PHONY: update docs

all: update

update:
	./scripts/update_helm.sh

docs:
	for c in charts/*; do \
		[[ $$c =~ "kubezero-lib" ]] && continue ; \
		[[ $$c =~ "kubeadm" ]] && continue ; \
		helm-docs -c $$c ; \
	done

publish:
	./scripts/publish.sh
