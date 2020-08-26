#!/bin/bash

REPODIR=/root/src/review.opencontrail.org/Juniper/contrail-container-builder

[ -d ${REPODIR} ] || git clone https://github.com/tungstenfabric/tf-container-builder  ${REPODIR}
cp tpc.repo.template common.env ${REPODIR}
cd ${REPODIR}/containers && ./build.sh
