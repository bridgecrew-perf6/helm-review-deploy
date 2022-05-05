FROM ubuntu:20.04 AS tools

WORKDIR /tools

RUN apt update && \
    apt install -y curl tar xz-utils

RUN curl -sLO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

RUN curl -sLO https://github.com/cloudflare/cloudflare-go/releases/download/v0.38.0/flarectl_0.38.0_linux_amd64.tar.xz && \
    tar -xpJf flarectl_0.38.0_linux_amd64.tar.xz


FROM anatolygusev/helm-secrets

COPY --from=tools --chmod=0755 /tools/kubectl /usr/local/bin/kubectl

COPY --from=tools --chmod=0755 /tools/flarectl /usr/local/bin/flarectl

RUN apk add --no-cache \
        python3 \
        py3-pip \
        jq \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
        awscli \
    && rm -rf /var/cache/apk/*

