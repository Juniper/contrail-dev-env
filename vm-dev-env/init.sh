#!/bin/bash

WORKDIR=${1:-$(pwd)}

echo downloading repo tool...
curl -s https://storage.googleapis.com/git-repo-downloads/repo > /tmp/repo \
  && sudo cp /tmp/repo /usr/bin/repo \
  && sudo chmod a+x /usr/bin/repo

echo adding contrail-tpc repository
sudo tee /etc/yum.repos.d/tpc.repo << EOF 
[contrail-tpc]
name=Third parties for Contrail
baseurl=http://148.251.5.90/tpc/
enabled=1
gpgcheck=0
EOF

echo installing reuquired packages
sudo yum -y update
sudo yum -y install \
  createrepo \
  docker \
  docker-python \
  gcc \
  gdb \
  git \
  kernel \
  make \
  python-devel \
  python-pip \
  rpm-build \
  vim \
  wget \
  yum-utils

echo Creating directory ${WORKDIR}/contrail...
mkdir -p ${WORKDIR}/contrail

echo configuring  git
git config --global user.email "${USER}@${HOSTNAME}"
git config --global user.name "${USER}"
git config --global color.ui auto

echo initializing sandbox...
cd ${WORKDIR}/contrail

test -d ${WORKDIR}/contrail/.repo || repo init --no-clone-bundle -q -u https://github.com/Juniper/contrail-vnc 
repo sync --no-clone-bundle -q -j $(($(nproc)*2 ))

echo cloning contrail-dev-env...
cd ${WORKDIR}
git clone https://github.com/Juniper/contrail-dev-env

echo Sandbox directory: ${WORKDIR}/contrail
echo dev-env directory: ${WORKDIR}/contrail-dev-env
echo
