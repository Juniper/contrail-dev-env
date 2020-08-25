#!/bin/bash

REPODIR=/root/src/review.opencontrail.org/Juniper/contrail-deployers-containers
BRANCH=${SB_BRANCH:-master}

[ -d ${REPODIR} ] || git clone https://github.com/tungstenfabric/tf-deployers-containers -b ${BRANCH}  ${REPODIR}
cp tpc.repo.template common.env ${REPODIR}
