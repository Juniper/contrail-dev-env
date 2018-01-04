#!/bin/bash
CONTRAIL_BRANCH=master
REPO_SYNC_THREADS=8

SANDBOX_ROOT="$1"

mkdir -p "$SANDBOX_ROOT"
cd "$SANDBOX_ROOT"

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global color.ui true # prevent repo asking interactively for color settings

# download manifest.xml
repo init --no-clone-bundle -u https://github.com/Juniper/contrail-vnc -b $CONTRAIL_BRANCH

# fetch all repositories
repo sync --no-clone-bundle -j $REPO_SYNC_THREADS
