FROM registry.hub.docker.com/library/debian:buster-slim

LABEL Maintainer="software-embedded@ultimaker.com" \
      Comment="Ultimaker update-tools filesystem"

RUN apt-get update && apt-get install -y \
        python3 \
        python-all \
        python3-all \
        python3-pip \
        python3-stdeb \
        python3-setuptools \
    && \
    apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/*

