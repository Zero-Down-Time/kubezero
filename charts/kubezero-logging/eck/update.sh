#!/bin/bash

ECK_VERSION=1.2.1

curl -o all-in-one.yaml https://download.elastic.co/downloads/eck/${ECK_VERSION}/all-in-one.yaml

kubectl kustomize . > ../templates/eck-operator.yaml
