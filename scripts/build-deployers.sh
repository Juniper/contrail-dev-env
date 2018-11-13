#!/bin/bash

REPODIR=/root/src/review.opencontrail.org/Juniper/contrail-deployers-containers

[ -d ${REPODIR} ] || git clone https://github.com/Juniper/contrail-deployers-containers  ${REPODIR}
cp tpc.repo.template common.env ${REPODIR}
cd ${REPODIR}/containers && ./build.sh
