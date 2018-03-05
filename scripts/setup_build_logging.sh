#!/bin/env bash
set -u

SRC_DIR=${1:-/root/src/review.opencontrail.org/Juniper}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d ${HOME}/contrail-build-logs ]; then
   mkdir -p ${HOME}/contrail-build-logs/contrail-logs
fi

for repo in "contrail-zuul-jobs"; do
  repo_dir=${SRC_DIR}/${repo}
  patch_file=${DIR}/${repo}.patch

  pushd ${repo_dir} >/dev/null
  git apply --check ${patch_file} >/dev/null
  rc=$?
  
  if [[ $rc == "0" ]]; then
    git apply -v ${patch_file}
    echo "[OK] Applied ${patch_file} on ${repo}"
  else
    echo "[ERROR] Patch ${patch_file} cannot be applied on ${repo}." >&2
    exit 1
  fi
  popd >/dev/null
done

