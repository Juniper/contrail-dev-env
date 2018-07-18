#!/bin/bash
TAG=${1:-centos-7.4-r5.0}
echo Building contrail-dev-env image: opencontrail/developer-sandbox:${TAG}
docker build --no-cache --tag opencontrail/developer-sandbox:${TAG} .
