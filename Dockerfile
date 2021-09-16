FROM amd64/debian:buster-slim
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        curl \
        apache2-utils \
        && rm -rf /var/lib/apt/lists/*


ARG USER_NAME=""
ENV USER ${USER_NAME:-bindleuser}

RUN groupadd --gid 1000 ${USER} &&  useradd -s /bin/bash --uid 1000 --gid 1000 -m ${USER}  
RUN mkdir /data && chown ${USER} /data && chgrp ${USER} /data 
RUN su ${USER} -c "mkdir -p /data/bindleserver &&  mkdir -p /data/logs"

ARG BINDLE_PORT="8080"
ENV BINDLE_URL http://localhost:${BINDLE_PORT}/v1  
ENV BINDLE_LISTEN_ADDRESS 0.0.0.0:${BINDLE_PORT}     

ARG BINDLE_SERVER_USER=""
ENV BINDLE_USERNAME ${BINDLE_SERVER_USER:-bindleuser}

ARG BINDLE_VERSION="v0.5.0"
RUN mkdir bindle && cd bindle && curl -fsSLo bindle.tar.gz https://bindle.blob.core.windows.net/releases/bindle-${BINDLE_VERSION}-linux-amd64.tar.gz && tar -xvf bindle.tar.gz && mv bindle bindle-server README.md LICENSE.txt /usr/local/bin/ && cd - && rm -r bindle

USER 1000

ENTRYPOINT if [ -z ${BINDLE_PASSWORD} ]; then export BINDLE_PASSWORD=$(openssl rand -base64 12);echo BINDLE_PASSWORD=${BINDLE_PASSWORD} >> ~/.bashrc;  fi && echo ${BINDLE_PASSWORD}|htpasswd -Bic /data/bindleserver/bindle-htpasswd ${BINDLE_USERNAME} && RUST_LOG=info bindle-server -i ${BINDLE_LISTEN_ADDRESS} --htpasswd-file /data/bindleserver/bindle-htpasswd -d /data/bindleserver  2>&1 | tee /data/logs/bindle-server.log