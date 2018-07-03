#!/bin/bash

REPODIR=/root/src/review.opencontrail.org/Juniper/contrail-container-builder
BRANCH=${SB_BRANCH:-master}

[ -d ${REPODIR} ] || git clone https://github.com/Juniper/contrail-container-builder -b ${BRANCH}  ${REPODIR}
cp tpc.repo.template common.env ${REPODIR}
