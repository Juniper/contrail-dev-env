#!/bin/bash

set -o nounset
set -o errexit

scriptdir=$(dirname "$0")
cd "$scriptdir"

function is_created () {
  local container=$1
  docker ps -a --format '{{ .Names }}' | grep "$container" > /dev/null
  return $?
}

function is_up () {
  local container=$1
  docker inspect --format '{{ .State.Status }}' $container | grep "running" > /dev/null
  return $?
}

echo contrail-dev-env startup
echo
echo '[docker setup]'

distro=$(cat /etc/*release | egrep '^ID=' | awk -F= '{print $2}' | tr -d \")
echo $distro detected.
if [ x"$distro" == x"centos" ]; then
   yum install -y docker
   systemctl stop firewalld || true
   sed -i 's/DOCKER_STORAGE_OPTIONS=/DOCKER_STORAGE_OPTIONS=--storage-opt dm.basesize=20G /g' /etc/sysconfig/docker-storage
   systemctl start docker
fi

echo
echo '[environment setup]'
echo "volume $(docker volume create --name contrail-dev-env-rpms) created."

if ! is_created "contrail-dev-env-rpm-repo"; then
  docker run --privileged --name contrail-dev-env-rpm-repo \
  -d -p 6667:80 \
  -v contrail-dev-env-rpm-volume:/var/www/localhost/htdocs \
  sebp/lighttpd >/dev/null
  echo contrail-dev-env-rpm-repo created.
else
  if is_up "contrail-dev-env-rpm-repo"; then
    echo "contrail-dev-env-rpm-repo already running."
  else
    echo $(docker start contrail-dev-env-rpm-repo) started.
  fi
fi

if ! is_created "contrail-dev-env-registry"; then
  docker run --privileged --name contrail-dev-env-registry \
  -d -p 6666:5000 \
  registry:2 >/dev/null
  echo contrail-dev-env-registry created.
else
  if is_up "contrail-dev-env-registry"; then
    echo "contrail-dev-env-registry already running."
  else
    echo $(docker start contrail-dev-env-registry) started.
  fi
fi

if ! is_created "contrail-developer-sandbox"; then
  docker run --privileged --name contrail-developer-sandbox \
  -w /root -itd \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v contrail-dev-env-rpm-volume:/root/contrail/RPMS \
  -v $(pwd):/root/contrail-dev-env \
  opencontrail/developer-sandbox:centos-7.4-slim >/dev/null
  echo contrail-developer-sandbox created.
else
  if is_up "contrail-developer-sandbox"; then
    echo "contrail-developer-sandbox already running."
  else
    echo $(docker start contrail-developer-sandbox) started.
  fi
fi

echo
echo '[configuration update]'
rpm_repo_ip=$(docker inspect --format '{{ .NetworkSettings.Gateway }}' contrail-dev-env-rpm-repo)
registry_ip=$(docker inspect --format '{{ .NetworkSettings.Gateway }}' contrail-dev-env-registry)

sed -e "s/rpm-repo/${rpm_repo_ip}/g" -e "s/registry/${registry_ip}/g" common.env.tmpl > common.env
sed -e "s/rpm-repo/${rpm_repo_ip}/g" -e "s/contrail-registry/${registry_ip}/g" vars.yaml.tmpl > vars.yaml
sed -e "s/rpm-repo/${rpm_repo_ip}/g" -e "s/registry/${registry_ip}/g" dev_config.yaml.tmpl > dev_config.yaml
sed -e "s/registry/${registry_ip}/g" daemon.json.tmpl > daemon.json

if [ x"$distro" == x"centos" ]; then
   diff daemon.json /etc/docker/daemon.json || (cp daemon.json /etc/docker/daemon.json && systemctl reload docker)
elif [ x"$distro" == x"ubuntu" ]; then
   diff daemon.json /etc/docker/daemon.json || (cp daemon.json /etc/docker/daemon.json && service docker reload)
fi

echo
echo '[READY]'
echo "You can now connect to the sandbox container by using: $ docker attach contrail-developer-sandbox"

