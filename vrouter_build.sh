#!/usr/bin/env bash

set -ex

function setup_dev_env () {
    rm -rf /root/contrail-dev-env
    git clone https://github.com/Juniper/contrail-dev-env /root/contrail-dev-env
    cd contrail-dev-env
    ./startup.sh
    docker exec -it contrail-developer-sandbox /root/contrail/vrouter_build.sh
}

function checkout_code () {
    cd $CONTRAIL
    repo sync
}

function test_vrouter () {
    insmod /root/vrouter/vrouter.ko
    lsmod | grep vrouter | grep -v grep
    rmmod vrouter
}

function build_vrouter () {
    cd $CONTRAIL
    python3 third_party/fetch_packages.py
    scons -uj8 vrouter
}

function main () {
    checkout_code
    build_vrouter
    test_vrouter
}

main
