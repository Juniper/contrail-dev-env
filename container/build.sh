#!/bin/bash
TAG=${1:-centos-7.4}
docker build --no-cache --tag opencontrail/developer-sandbox:${TAG} .
