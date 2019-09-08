FROM lsiobase/alpine:3.10

# global environment settings
ENV PLATFORM_ARCH="amd64"
ARG RCLONE_VERSION="current"

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# install packages
RUN \
  apk update && \
  apk add --no-cache \
  ca-certificates

# install build packages
RUN \
  apk add --no-cache --virtual=build-dependencies \
                wget \
                curl \
                unzip && \
# install rclone
  cd tmp && \
    wget -q https://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    unzip /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin && \
    apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/community \
        shadow && \
# cleanup
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    /var/tmp/* \
    /var/cache/apk/*

# create abc user
RUN \
# create some files / folders
    mkdir -p /config /app /defaults /data && \
    touch /var/lock/rclone.lock

# add local files
COPY root/ /

VOLUME /config
