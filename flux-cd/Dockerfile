FROM debian:stretch

LABEL "com.github.actions.name"="Under Armour - CD w/ Flux"
LABEL "com.github.actions.description"="Continuously deploy kubernetes manifests"
LABEL "com.github.actions.icon"="cpu"
LABEL "com.github.actions.color"="red"

LABEL "repository"="http://github.com/underarmour/github-actions"
LABEL "homepage"="http://github.com/underarmour/github-actions"
LABEL "maintainer"="Under Armour <ops@underarmour.com>"

RUN apt update -y && apt install -y curl git && \
    curl -sLO https://github.com/github/hub/releases/download/v2.9.0/hub-linux-amd64-2.9.0.tgz && \
    tar -xzf ./hub-linux-amd64-2.9.0.tgz && \
    chmod +x ./hub-linux-amd64-2.9.0/bin/hub && \
    mv ./hub-linux-amd64-2.9.0/bin/hub /usr/local/bin/hub && \
    rm -rf ./hub-linux-amd64-2.9.0 && rm ./hub-linux-amd64-2.9.0.tgz

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]