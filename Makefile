BUCKET ?= zero-downtime
BUCKET_PREFIX ?= /cloudbender/distfiles
FILES ?= distfiles.txt

.PHONY: update docs

all: update

update:
	./script/update_helm.sh

docs:
	for c in charts/*; do \
		[[ $$c =~ "kubezero-lib" ]] && continue ; \
		[[ $$c =~ "kubeadm" ]] && continue ; \
		helm-docs -c $$c ; \
	done
