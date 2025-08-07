FROM debian:bookworm AS builder

RUN apt-get update && apt-get install -y \
    microsocks \
    openvpn \
    iproute2 \
    procps

WORKDIR /
COPY ./entrypoint.sh ./

ENTRYPOINT ["/entrypoint.sh"]