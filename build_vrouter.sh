#!/usr/bin/env bash

# Use following commands to checkout and build contrail-vrouter
#
# sudo docker rm -f rhel7; sudo docker run -it --name=rhel7 --privileged -v /lib/modules:/lib/modules rhel7 bash -ex build_vrouter.sh
#
# This script executes necessary minimal steps in order to quickly checkout and build contrail-vrouter kernel module.
# Exits with code zero on success, non-zero on failure.

set -ex

TOP="$PWD/build_vrouter"
RPM_PACKAGES="kernel-devel-$(uname -r) autoconf automake libtool flex bison gcc-c++ boost-devel git make python2-pip"
PYTHON_PACKAGES="scons"

function setup () {
    yum-config-manager rhel-server-rhscl-7-rpms
    yum -y update
    yum -y install $RPM_PACKAGES
    pip install $PYTHON_PACKAGES
    git config --global user.email "anantha@juniper.net"
    git config --global user.name "Ananth Suryanarayana"
    git config --global color.ui true
}

function teardown () {
#   yum -y remove $RPM_PACKAGES
#   pip uninstall $PYTHON_PACKAGES
    rm -rf $TOP
}

function update_manifest () {
    cat > $TOP/.repo/manifest.xml<<EOF
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
    mkdir -p $TOP
    if [ ! -f /usr/bin/repo ]; then
        curl -s https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
        chmod +x /usr/bin/repo
    fi
    cd $TOP
    repo init --quiet -u https://github.com/tungstenfabric/tf-vnc.git
    update_manifest
    repo sync -j$(nproc)
}

function build () {
    scons -uj$(nproc) -C $TOP build-kmodule
}

function verify () {
    insmod $TOP/vrouter/vrouter.ko
    lsmod | grep vrouter | grep -v grep
    rmmod vrouter
}

function main () {
    setup
    checkout
    build
    verify
    teardown
}

main
