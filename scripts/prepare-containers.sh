#!/bin/bash

REPODIR=/root/src/review.opencontrail.org/Juniper/contrail-container-builder

[ -d ${REPODIR} ] || git clone https://github.com/Juniper/contrail-container-builder -b r5.0 ${REPODIR}
cp tpc.repo.template common.env ${REPODIR}
