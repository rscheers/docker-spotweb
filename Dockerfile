FROM multiarch/debian-debootstrap:armhf-buster-slim

ENV ARCH armhf
ENV S6OVERLAY_RELEASE https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-arm.tar.gz
# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV SPOTWEB_RELEASE_TYPE="Release"

COPY install-spotweb.sh /usr/local/bin/install-spotweb.sh
COPY VERSION /etc/docker-spotweb-version

RUN bash -ex install-spotweb.sh 2>&1 && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENTRYPOINT [ "/s6-init" ]

COPY	dbsettings.inc.php /var/www/spotweb/dbsettings.inc.php
RUN		chown -R www-data:www-data /var/www

#ADD		nginx.conf /etc/nginx/nginx.conf
COPY		spotweb.conf /etc/nginx/sites-enabled/spotweb.conf

# IPv6 disable flag for networks/devices that do not support it
ENV IPv6 True

EXPOSE 80

ENV S6_LOGGING 0
ENV S6_KEEP_ENV 1
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2


# set version label
ARG BUILD_DATE
ARG VERSION
ARG SPOTWEB_RELEASE
LABEL build_version="rwscheers version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL image="rwscheers/spotweb:v1.0_armhf"
LABEL maintainer="rwscheers@hotmail.com"
LABEL url="https://www.github.com/pi-hole/docker-pi-hole"

#SHELL ["/bin/bash", "-c"]
