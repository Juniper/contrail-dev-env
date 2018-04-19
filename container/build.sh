#!/bin/bash
BRANCH=master

while getopts ":b:" opt; do
    case $opt in
      b) BRANCH=$OPTARG
         ;;
      \?) echo "Invalid option: $opt"; exit 1;;
    esac
done

shift $((OPTIND-1))

TAG=${1:-centos-7.4}
echo Building contrail-dev-env image: opencontrail/developer-sandbox:${TAG}
docker build --build-arg BRANCH=${BRANCH} --no-cache --tag opencontrail/developer-sandbox:${TAG} .
