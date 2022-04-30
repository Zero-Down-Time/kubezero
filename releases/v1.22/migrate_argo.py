#!/usr/bin/env python3
import sys
import argparse
import io
import ruamel.yaml


yaml = ruamel.yaml.YAML()
yaml.preserve_quotes = True
yaml.explicit_start = True
yaml.indent(mapping=2, sequence=4, offset=2)


parser = argparse.ArgumentParser(description="Update Route53 entries")
parser.add_argument(
    "--version",
    dest="version",
		default="1.22.8-5",
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

# New Istio Gateway charts
if "private" in values["istio-ingress"]:
    values["istio-private-ingress"] = {
        "enabled": True,
        "certificates": values["istio-ingress"]["private"]["certificates"].copy()
    }

    if "gateway" in values["istio-ingress"]["private"]:
        values["istio-private-ingress"]["gateway"] = {}

        try:
            values["istio-private-ingress"]["gateway"]["replicaCount"] = values["istio-ingress"]["private"]["gateway"]["replicaCount"]
        except KeyError:
            pass

        if "ports" in values["istio-ingress"]["private"]["gateway"]:
            values["istio-private-ingress"]["gateway"]["service"] = {}
            values["istio-private-ingress"]["gateway"]["service"]["ports"] = []
            for port in values["istio-ingress"]["private"]["gateway"]["ports"]:
                if port["name"] not in ["status-port", "http2", "https"]:
                    values["istio-private-ingress"]["gateway"]["service"]["ports"].append(port)

    values["istio-ingress"].pop("private")

if "public" in values["istio-ingress"]:
    values["istio-ingress"]["certificates"] = values["istio-ingress"]["public"]["certificates"].copy()

    if "gateway" in values["istio-ingress"]["public"]:
        values["istio-ingress"]["gateway"] = {}

        try:
            values["istio-ingress"]["gateway"]["replicaCount"] = values["istio-ingress"]["public"]["gateway"]["replicaCount"]
        except KeyError:
            pass

        if "ports" in values["istio-ingress"]["public"]["gateway"]:
            values["istio-ingress"]["gateway"]["service"] = {}
            values["istio-ingress"]["gateway"]["service"]["ports"] = []
            for port in values["istio-ingress"]["public"]["gateway"]["ports"]:
                if port["name"] not in ["status-port", "http2", "https"]:
                    values["istio-ingress"]["gateway"]["service"]["ports"].append(port)

    values["istio-ingress"].pop("public")

if "global" in values["istio-ingress"]:
    values["istio-ingress"].pop("global")

# Remove Kiam
if "kiam" in values:
    values.pop("kiam")

### End

# Merge new values
buffer = io.StringIO()
yaml.dump(values, buffer)
application["spec"]["source"]["helm"]["values"] = buffer.getvalue()

# Dump final yaml
yaml.dump(application, sys.stdout)
