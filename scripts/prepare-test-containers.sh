#!/bin/bash -e

REPODIR=/root/src/review.opencontrail.org/Juniper/contrail-test
BRANCH=${SB_BRANCH:-master}

[ -d ${REPODIR} ] || git clone https://github.com/tungstenfabric/tf-test -b ${BRANCH}  ${REPODIR}
cp common.env ${REPODIR}
if [ -f tpc.repo.template ]; then
  cp tpc.repo.template ${REPODIR}/docker/base/tpc.repo
  cp tpc.repo.template ${REPODIR}/docker/test/tpc.repo
fi
