#!/bin/bash
TAG=${1:-centos-7.4}
docker build --tag opencontrail/developer-sandbox:${TAG} .
