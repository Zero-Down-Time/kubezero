#!/usr/bin/env python3
import sys
import argparse
import io
import ruamel.yaml


yaml = ruamel.yaml.YAML()
yaml.preserve_quotes = True
yaml.explicit_start = True
yaml.indent(mapping=2, sequence=4, offset=2)


def rec_sort(d):
    if isinstance(d, dict):
        res = dict()

        # Always have "enabled" first if present
        if "enabled" in d.keys():
            res["enabled"] = rec_sort(d["enabled"])
            d.pop("enabled")

        # next is "name" if present
        if "name" in d.keys():
            res["name"] = rec_sort(d["name"])
            d.pop("name")

        for k in sorted(d.keys()):
            res[k] = rec_sort(d[k])
        return res
    if isinstance(d, list):
        for idx, elem in enumerate(d):
            d[idx] = rec_sort(elem)
    return d


parser = argparse.ArgumentParser(description="Migrate ArgoCD Kubezero values to new cluster config")
parser.add_argument(
    "--version",
    dest="version",
		default="1.23.10",
    action="store",
    required=False,
    help="Update KubeZero version",
)

args = parser.parse_args()

application = yaml.load(sys.stdin)

# Set version from cmd line
if args.version:
    application["spec"]["source"]["targetRevision"] = args.version

# Extract Helm values
values = yaml.load(application["spec"]["source"]["helm"]["values"])

### Do your thing

# migrate ClusterName to clusterName
if "ClusterName" in values:
    values["clusterName"] = values["ClusterName"]
    values.pop("ClusterName")

# Create new clusterwide cloudprovider data if possible
try:
    if values["cert-manager"]["clusterIssuer"]["solvers"][0]["dns01"]["route53"]["regions"]:
        if "aws" not in values:
            values["aws"] = {}
        values["aws"]["region"] = values["cert-manager"]["clusterIssuer"]["solvers"][0]["dns01"]["route53"]["region"]
except KeyError:
    pass

### End

# Merge new values
buffer = io.StringIO()
yaml.dump(rec_sort(values), buffer)
application["spec"]["source"]["helm"]["values"] = buffer.getvalue()

# Dump final yaml
yaml.dump(application, sys.stdout)
