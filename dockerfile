FROM debian:bookworm AS builder

RUN apt-get update && apt-get install -y \
    microsocks \
    openvpn \
    iproute2 \
    procps \
    sudo

#Create isolated users for runtimes
RUN adduser --system --no-create-home --shell /usr/sbin/nologin --group openvpn && \
    adduser --system --no-create-home --shell /usr/sbin/nologin --group microsocks

WORKDIR /
COPY ./entrypoint.sh ./

ENTRYPOINT ["/entrypoint.sh"]