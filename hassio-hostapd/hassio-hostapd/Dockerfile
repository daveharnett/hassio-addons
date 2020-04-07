ARG BUILD_FROM
FROM $BUILD_FROM

MAINTAINER Dave Harnett <daveharnett@gmail.com>

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk update && apk add --no-cache hostapd util-linux procps iproute2 iw make sudo && rm -rf /var/cache/apk/*

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
