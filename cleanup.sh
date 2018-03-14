#!/bin/bash

for container in "contrail-developer-sandbox contrail-dev-env-registry contrail-dev-env-rpm-repo"; do
  echo Stopped $(docker stop $container).
  echo Removed $(docker rm $container).
done
