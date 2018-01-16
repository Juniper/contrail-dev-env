#!/bin/bash
CONTRAIL_BRANCH=master
REPO_SYNC_THREADS=8

SANDBOX_ROOT="$1"

mkdir -p "$SANDBOX_ROOT"
cd "$SANDBOX_ROOT"

# setup git config for sandbox repository
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# XXX: repo not asking interactively for color settings and
# prevents build playbook from fail due to building scripts
# are colorless sensible 
git config --global color.ui false

# download manifest.xml
repo init --no-clone-bundle -u https://github.com/Juniper/contrail-vnc -b $CONTRAIL_BRANCH

# fetch all repositories
repo sync --no-clone-bundle -j $REPO_SYNC_THREADS
