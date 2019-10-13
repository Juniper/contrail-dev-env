#!/usr/bin/env bash

set -ex

function setup_dev_env () {
    rm -rf /root/contrail-dev-env
    git clone https://github.com/Juniper/contrail-dev-env /root/contrail-dev-env
    cd contrail-dev-env
    ./startup.sh
}

function setup () {
    git config --global user.email "anantha@juniper.net"
    git config --global user.name "Ananth Suryanarayana"
    git config --global color.ui true
    yum -y install kernel-devel
}

# dev_env
function checkout_code () {
    rm -rf /root/vrouter
    mkdir -p /root/vrouter
    repo init -b master --quiet -u https://github.com/Juniper/contrail-vnc
    repo sync
}

function build_vrouter () {
    python3 third_party/fetch_packages.py
    scons vrouter
}

function test_vrouter () {
    insmod /root/vrouter/vrouter.ko
    lsmod | grep vrouter | grep -v grep
    rmmod vrouter
}

function main () {
    setup
    checkout_code
    build_vrouter
    test_vrouter
}

main
