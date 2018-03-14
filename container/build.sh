#!/bin/bash
TAG=${1:-centos-7.4-slim}
docker build --tag opencontrail/developer-sandbox:${TAG} .
