ARG BUILD_FROM=hassioaddons/base:7.0.3
FROM ${BUILD_FROM}

MAINTAINER Dave Harnett <daveharnett@gmail.com>

# Set shell
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#ENV LANG C.UTF-8

# Copy root filesystem
COPY rootfs /


# Install requirements for add-on
RUN apk update && \
    apk add --no-cache \
    bash \
    jq \
    hostapd \
    networkmanager \
    util-linux \
    procps \
    iproute2 \
    iw \
    make \
    sudo \
    && rm -rf /var/cache/apk/*

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION


#RUN echo ls
#COPY run.sh /
#RUN chmod a+x /run.sh

#RUN echo ls /

#CMD [ "/run.sh" ]
