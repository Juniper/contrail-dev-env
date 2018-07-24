#!/bin/bash
BRANCH=master
IMAGE=opencontrail/developer-sandbox

while getopts ":b:i:" opt; do
    case $opt in
      b) BRANCH=$OPTARG
         ;;
      i) IMAGE=$OPTARG
         ;;
      \?) echo "Invalid option: $opt"; exit 1;;
    esac
done

shift $((OPTIND-1))

TAG=${1:-centos-7.4}
echo Building contrail-dev-env image: ${IMAGE}:${TAG}
docker build --build-arg BRANCH=${BRANCH} --no-cache --tag opencontrail/developer-sandbox:${TAG} .
