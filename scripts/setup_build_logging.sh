#!/bin/env bash
set -u

if [ ! -d $HOME/contrail-build-logs ]; then
   mkdir -p $HOME/contrail-build-logs/contrail-logs
fi

task_dir=$(pwd)/code/contrail-project-config/roles/packaging-build-el/tasks
patch_dir=$(pwd)/scripts

if ! patch -R -p0 -s -f --dry-run ${task_dir}/main.yaml < ${patch_dir}/packaging-build-el-tasks.patch; then
  patch -p0 ${task_dir}/main.yaml < ${patch_dir}/packaging-build-el-tasks.patch
fi
