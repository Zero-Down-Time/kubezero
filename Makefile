BUCKET ?= zero-downtime
BUCKET_PREFIX ?= /cloudbender/distfiles
FILES ?= distfiles.txt

.PHONY: clean update

all: update


clean:
	rm -f kubezero*.tgz

update:
	./script/update_helm.sh
