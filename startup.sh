#!/bin/bash

mydir=$(dirname "$0")
cd "$mydir"

distro=$(cat /etc/*release | egrep '^ID=' | awk -F= '{print $2}' | tr -d \")
echo Distro detected: $distro
if [ x"$distro" == x"centos" ]; then
   yum install -y docker
   systemctl stop firewalld
   sed -i 's/DOCKER_STORAGE_OPTIONS=/DOCKER_STORAGE_OPTIONS=--storage-opt dm.basesize=20G /g' /etc/sysconfig/docker-storage
fi

docker volume create --name contrail-dev-env-rpms
docker run --privileged --name contrail-dev-env-rpm-repo \
-d -p 6667:80 \
-v contrail-dev-env-rpm-volume:/var/www/localhost/htdocs \
sebp/lighttpd || docker start contrail-dev-env-rpm-repo

docker run --privileged --name contrail-dev-env-registry \
-d -p 6666:5000 \
registry:2 || docker start contrail-dev-env-registry

docker run --privileged --name contrail-developer-sandbox \
-w /root -itd \
-v /var/run/docker.sock:/var/run/docker.sock \
-v contrail-dev-env-rpm-volume:/root/rpmbuild/RPMS \
-v $(pwd):/root/contrail-dev-env \
opencontrail/developer-sandbox:centos-7.4 || docker start contrail-developer-sandbox

rpm_repo_ip=$(docker inspect contrail-dev-env-rpm-repo --format '{{ .NetworkSettings.IPAddress }}')
registry_ip=$(docker inspect contrail-dev-env-registry --format '{{ .NetworkSettings.IPAddress }}')

sed -e "s/rpm-repo/${rpm_repo_ip}/g" -e "s/registry/${registry_ip}/g" common.env.tmpl > common.env
sed -e "s/rpm-repo/${rpm_repo_ip}/g" -e "s/contrail-registry/${registry_ip}/g" vars.yaml.tmpl > vars.yaml
sed -e "s/rpm-repo/${rpm_repo_ip}/g" -e "s/registry/${registry_ip}/g" dev_config.yaml.tmpl > dev_config.yaml
sed -e "s/registry/${registry_ip}/g" daemon.json.tmpl > daemon.json

if [ x"$distro" == x"centos" ]; then
   diff daemon.json /etc/docker/daemon.json || (cp daemon.json /etc/docker/daemon.json && systemctl restart docker)
elif [ x"$distro" == x"ubuntu" ]; then
   diff daemon.json /etc/docker/daemon.json || (cp daemon.json /etc/docker/daemon.json && service docker restart)
fi

echo "You can now connect to the sandbox container by using: $ docker attach contrail-developer-sandbox"


