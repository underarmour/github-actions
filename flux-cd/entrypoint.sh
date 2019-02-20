#!/bin/sh -l

if [ "$GITHUB_REF" != "refs/heads/master" ]; then
    echo "[UA] Skipping this commit because its not a commit to the 'master' branch"
    exit 0
fi

echo "[UA] Beginning Flux CD Process..."

git config credential.helper "/bin/bash /usr/local/bin/git-credential-helper.sh"

mkdir -p /flux
cd /flux
hub clone underarmour/flux-kubernetes
cd $GITHUB_WORKSPACE

OPS_GLOBAL=$GITHUB_WORKSPACE/ops/global
OPS_US=$GITHUB_WORKSPACE/ops/us
OPS_CHINA=$GITHUB_WORKSPACE/ops/china

if [ -d "$OPS_GLOBAL" ]; then
    mkdir -p /flux/global/automated/$GITHUB_REPOSITORY
    cp -r $OPS_GLOBAL /flux/global/automated/$GITHUB_REPOSITORY
    echo "[UA] Copying '$OPS_GLOBAL' files to flux repo."
fi

if [ -d "$OPS_US" ]; then
    mkdir -p /flux/us/automated/$GITHUB_REPOSITORY
    cp -r $OPS_US /flux/us/automated/$GITHUB_REPOSITORY
    echo "[UA] Copying '$OPS_US' files to flux repo."
fi

if [ -d "$OPS_CHINA" ]; then
    mkdir -p /flux/tokyo/automated/$GITHUB_REPOSITORY
    cp -r $OPS_CHINA /flux/tokyo/automated/$GITHUB_REPOSITORY
    echo "[UA] Copying '$OPS_CHINA' files to flux repo."
fi

cd /flux
git status