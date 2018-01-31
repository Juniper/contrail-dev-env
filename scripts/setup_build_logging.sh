#!/bin/env bash
set -u

if [ ! -d $HOME/contrail-build-logs ]; then
   mkdir -p $HOME/contrail-build-logs
fi

TASK_DIR=$(pwd)/code/contrail-project-config/roles/packaging-build-el/tasks
PATCH_DIR=$(pwd)/scripts

if ! patch -R -p0 -s -f --dry-run ${TASK_DIR}/main.yaml < ${PATCH_DIR}/packaging-build-el-tasks.patch; then
  patch -p0 ${TASK_DIR}/main.yaml < ${PATCH_DIR}/packaging-build-el-tasks.patch
fi
