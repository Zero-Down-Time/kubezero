BUCKET ?= zero-downtime
BUCKET_PREFIX ?= /cloudbender/distfiles
FILES ?= distfiles.txt

.PHONY: clean update docs

all: update


clean:
	rm -f kube*.tgz

update:
	./script/update_helm.sh

docs:
	for c in charts/*; do \
		[[ $$c =~ "kubezero-lib" ]] && continue ; \
		[[ $$c =~ "kubeadm" ]] && continue ; \
		helm-docs -c $$c ; \
	done
