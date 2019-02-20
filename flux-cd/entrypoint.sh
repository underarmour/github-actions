#!/bin/sh -l
set +x

if [ "$GITHUB_REF" != "refs/heads/master" ]; then
    echo "[UA] Skipping this commit because its not a commit to the 'master' branch"
    exit 0
fi

echo "[UA] Beginning Flux CD Process..."

# Needs to use https for private repo cloning
git config --global hub.protocol https
git config --global credential.helper "/bin/sh /usr/local/bin/git-credentials-helper.sh"
git config --global user.email "ops@underarmour.com"
git config --global user.name "jenkins-uacf"
export GITHUB_USER=jenkins-uacf
export GITHUB_PASSWORD=$GIT_PASSWORD

cd /
hub clone underarmour/flux-kubernetes
cd $GITHUB_WORKSPACE

FLUX_REPO="/flux-kubernetes"
OPS_GLOBAL="$GITHUB_WORKSPACE/ops/global/"
OPS_US="$GITHUB_WORKSPACE/ops/us/"
OPS_CHINA="$GITHUB_WORKSPACE/ops/china/"
MANIFEST_FOLDER="$(echo $GITHUB_REPOSITORY | cut -d '/' -f 2)"

if [ -d "$OPS_GLOBAL" ]; then
    mkdir -p $FLUX_REPO/global/automated/$MANIFEST_FOLDER
    cp -r $OPS_GLOBAL $FLUX_REPO/global/automated/$MANIFEST_FOLDER
    echo "[UA] Copying '$OPS_GLOBAL' files to flux repo."
fi

if [ -d "$OPS_US" ]; then
    mkdir -p $FLUX_REPO//us/automated/$MANIFEST_FOLDER
    cp -r $OPS_US $FLUX_REPO/us/automated/$MANIFEST_FOLDER
    echo "[UA] Copying '$OPS_US' files to flux repo."
fi

if [ -d "$OPS_CHINA" ]; then
    mkdir -p $FLUX_REPO//tokyo/automated/$MANIFEST_FOLDER
    cp -r $OPS_CHINA $FLUX_REPO/tokyo/automated/$MANIFEST_FOLDER
    echo "[UA] Copying '$OPS_CHINA' files to flux repo."
fi

cd $FLUX_REPO
git add -A
if ! git diff-index --quiet HEAD --; then
    git commit --quiet -a -m "Automated update of the k8s manifests from $GITHUB_REPOSITORY"
    git status
    # Allow for PRs? https://hub.github.com/hub-pull-request.1.html
    git push --quiet origin HEAD:refs/heads/master
    echo "[US] Pushed kubernetes manifest changes to flux repo"
fi
