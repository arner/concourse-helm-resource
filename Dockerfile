FROM linkyard/docker-helm:2.11.0
LABEL maintainer "mario.siegenthaler@linkyard.ch"

RUN apk add --update --upgrade --no-cache jq bash curl

ARG KUBERNETES_VERSION=1.11.3
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl; \
    chmod +x /usr/local/bin/kubectl

ARG IBMCLOUD_CLI_VERSION=0.11.0
RUN curl -L https://clis.ng.bluemix.net/download/bluemix-cli/${IBMCLOUD_CLI_VERSION}/linux32 > bx.tar.gz && \
    tar -zxf bx.tar.gz && \
    rm -rf bx.tar.gz && \
    /Bluemix_CLI/install_bluemix_cli && \
    ibmcloud config --check-version=false

RUN ibmcloud plugin install container-service -r Bluemix

ADD assets /opt/resource
RUN chmod +x /opt/resource/*

RUN mkdir -p "$(helm home)/plugins"
RUN helm plugin install https://github.com/databus23/helm-diff

ENTRYPOINT [ "/bin/bash" ]
