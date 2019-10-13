#!/usr/bin/env bash

# docker rm -f rhel7; docker run -it --name=rhel7  -v /lib/modules:/lib/modules rhel7 bash -ex build_vrouter.sh

set -ex

TOP="/root/build_vrouter"
TOPV="$TOP/vrouter"
PACKAGES="kernel-devel-$(uname -r) autoconf automake libtool flex bison gcc-c++ boost-devel git make"

function setup () {
    yum -y update
    yum -y install $PACKAGES
    curl -s "https://rpmfind.net/linux/epel/7/x86_64/Packages/p/python2-pip-8.1.2-10.el7.noarch.rpm" > pip.rpm
    yum -y install pip.rpm || true
    rm -rf pip.rpm
    pip install scons
    git config --global user.email "anantha@juniper.net"
    git config --global user.name "Ananth Suryanarayana"
    git config --global color.ui true
}

function teardown () {
    yum -y remove $PACKAGES
    pip uninstall scons
}

function update_manifest () {
    cat > $TOPV/.repo/manifest.xml<<EOF
<manifest>
<remote name="github" fetch="https://github.com/Juniper"/>
<default revision="refs/heads/master" remote="github"/>
<project name="contrail-build" remote="github" path="tools/build">
  <copyfile src="SConstruct" dest="SConstruct"/>
</project>
<project name="contrail-vrouter" remote="github" path="vrouter"/>
<project name="contrail-sandesh" remote="github" path="tools/sandesh"/>
<project name="contrail-common" remote="github" path="src/contrail-common"/>
</manifest>
EOF
}

function checkout () {
    rm -rf $TOP
    mkdir -p $TOPV
    curl https://storage.googleapis.com/git-repo-downloads/repo > $TOP/repo
    chmod +x $TOP/repo
    cd $TOPV
    $TOP/repo init --quiet -u https://github.com/Juniper/contrail-vnc.git
    update_manifest
    $TOP/repo sync
}

function build () {
    scons -uj8 -C $TOPV build-kmodule
}

function verify () {
    insmod $TOPV/vrouter/vrouter.ko
    lsmod | grep vrouter | grep -v grep
    rmmod vrouter
    rm -rf $TOP
}

function main () {
    setup
    checkout
    build
    verify
#   teardown
}

main
