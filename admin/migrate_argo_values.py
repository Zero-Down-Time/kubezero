#!/usr/bin/env python3
import sys
import argparse
import io
import yaml


def migrate(values):
    """Actual changes here"""

    # ClusterBackup is enabled on AWS anyways, same with cluster-autoscaler
    if "aws" in values["global"]:
        deleteKey(values["addons"], "clusterBackup")
        deleteKey(values["addons"], "cluster-autoscaler")

    # Remove calico and multus
    deleteKey(values["network"], "calico")
    deleteKey(values["network"], "multus")

    # ArgoCD helm changes
    if "argocd" in values:
        if "server" in values["argocd"]:
            if not "configs" in values["argocd"]:
                values["argocd"]["configs"] = {}
            if not "cm" in values["argocd"]["configs"]:
                values["argocd"]["configs"]["cm"] = {}
            values["argocd"]["configs"]["cm"]["url"] = values["argocd"]["server"]["config"][
                "url"
            ]
            deleteKey(values["argocd"], "server")

    return values


def deleteKey(values, key):
    """Delete key from dictionary if exists"""
    try:
        values.pop(key)
    except KeyError:
        pass

    return values


class MyDumper(yaml.Dumper):
    """
    Required to add additional indent for arrays to match yq behaviour to reduce noise in diffs
    """

    def increase_indent(self, flow=False, indentless=False):
        return super(MyDumper, self).increase_indent(flow, False)


def str_presenter(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
        return dumper.represent_scalar("tag:yaml.org,2002:str", data, style="|")
    return dumper.represent_scalar("tag:yaml.org,2002:str", data)


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


yaml.add_representer(str, str_presenter)

# to use with safe_dump:
yaml.representer.SafeRepresenter.add_representer(str, str_presenter)

# Read values
values = yaml.safe_load(sys.stdin)

# Output new values
buffer = io.StringIO()
yaml.dump(
    rec_sort(migrate(values)),
    sys.stdout,
    default_flow_style=False,
    indent=2,
    sort_keys=False,
    Dumper=MyDumper,
)
