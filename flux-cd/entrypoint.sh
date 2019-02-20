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
KUBE_GLOBAL="$GITHUB_WORKSPACE/kubernetes/global/"
KUBE_US="$GITHUB_WORKSPACE/kubernetes/us/"
KUBE_CHINA="$GITHUB_WORKSPACE/kubernetes/china/"
MANIFEST_FOLDER="$(echo $GITHUB_REPOSITORY | cut -d '/' -f 2)"

if [ -d "$KUBE_GLOBAL" ]; then
    mkdir -p $FLUX_REPO/global/automated/$MANIFEST_FOLDER
    cp -r $KUBE_GLOBAL $FLUX_REPO/global/automated/$MANIFEST_FOLDER
    echo "[UA] Copying '$KUBE_GLOBAL' files to flux repo."
fi

if [ -d "$KUBE_US" ]; then
    mkdir -p $FLUX_REPO/us/automated/$MANIFEST_FOLDER
    cp -r $KUBE_US $FLUX_REPO/us/automated/$MANIFEST_FOLDER
    echo "[UA] Copying '$KUBE_US' files to flux repo."
fi

if [ -d "$KUBE_CHINA" ]; then
    mkdir -p $FLUX_REPO/tokyo/automated/$MANIFEST_FOLDER
    cp -r $KUBE_CHINA $FLUX_REPO/tokyo/automated/$MANIFEST_FOLDER
    echo "[UA] Copying '$KUBE_CHINA' files to flux repo."
fi

cd $FLUX_REPO
git add -A
git status
if ! git diff-index --quiet HEAD --; then
    git commit --quiet -a -m "Automated update of the k8s manifests from $GITHUB_REPOSITORY at $GITHUB_SHA"
    # Allow for PRs? https://hub.github.com/hub-pull-request.1.html
    git push --quiet origin HEAD:refs/heads/master
    echo "[US] Pushed kubernetes manifest changes to flux repo"
fi
