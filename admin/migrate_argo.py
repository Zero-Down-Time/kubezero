#!/usr/bin/env python3
import sys
import argparse
import io
import yaml

DEFAULT_VERSION = "1.23.10-3"


def migrate(values):
    """Actual changes here"""

    # migrate ClusterName to clusterName
    if "ClusterName" in values:
        values["clusterName"] = values["ClusterName"]
        values.pop("ClusterName")

    # Create new clusterwide cloudprovider data if possible
    try:
        if values["cert-manager"]["clusterIssuer"]["solvers"][0]["dns01"]["route53"]["regions"]:
            if "global" not in values:
                values["global"] = {}
            if "aws" not in values["global"]:
                values["global"]["aws"] = {}

            values["global"]["aws"]["region"] = values["cert-manager"]["clusterIssuer"]["solvers"][0]["dns01"]["route53"]["region"]
    except KeyError:
        pass

    return values


def str_presenter(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
        return dumper.represent_scalar("tag:yaml.org,2002:str", data, style="|")
    return dumper.represent_scalar("tag:yaml.org,2002:str", data)


yaml.add_representer(str, str_presenter)

# to use with safe_dump:
yaml.representer.SafeRepresenter.add_representer(str, str_presenter)


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


parser = argparse.ArgumentParser(
    description="Migrate ArgoCD Kubezero values to new cluster config"
)
parser.add_argument(
    "--version",
    dest="version",
    default=DEFAULT_VERSION,
    action="store",
    required=False,
    help="Update KubeZero version",
)

args = parser.parse_args()

application = yaml.safe_load(sys.stdin)

# Set version from cmd line
if args.version:
    application["spec"]["source"]["targetRevision"] = args.version

# Extract Helm values
values = yaml.safe_load(application["spec"]["source"]["helm"]["values"])

# Merge new values
buffer = io.StringIO()
yaml.safe_dump(
    rec_sort(migrate(values)),
    buffer,
    default_flow_style=False,
    indent=2,
    sort_keys=False,
)
application["spec"]["source"]["helm"]["values"] = buffer.getvalue()

# Output new Application resource
yaml.dump(application, sys.stdout, default_flow_style=False)
