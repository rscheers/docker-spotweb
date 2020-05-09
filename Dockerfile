FROM lsiobase/ubuntu:arm32v7-bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SPOTWEB_RELEASE
LABEL build_version="rwscheers version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="rwscheers"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV SPOTWEB_RELEASE_TYPE="Release"

RUN \
 echo "**** install dependencies ****" && \
 apt-get update && \
 apt-get install -y \
	apache2 \
    mysql-server \
    php5-curl \
	php5 \
    php5-dom \
    php5-gettext \
    php5-mbstring \
    php5-xml \
    php5-zip \
    php5-zlib \
    php5-gd \
	unzip && \
 echo "**** install nzbhydra2 ****" && \
 if [ -z ${SPOTWEB_RELEASE+x} ]; then \
	SPOTWEB_RELEASE=$(curl -sX GET "https://api.github.com/repos/spotweb/spotweb/releases/latest" \
	| jq -r .tag_name); \
 fi && \
 SPOTWEB_VER=${SPOTWEB_RELEASE#v} && \
 curl -o \
 /tmp/spotweb.zip -L \
	"https://github.com/spotweb/spotweb/releases/download/v${SPOTWEB_VER}/spotweb-${SPOTWEB_VER}-linux.zip" && \
 mkdir -p /app/spotweb/bin && \
 unzip /tmp/spotweb.zip -d /app/spotweb/bin && \
 echo "ReleaseType=${SPOTWEB_RELEASE_TYPE}\nPackageVersion=${VERSION}\nPackageAuthor=rwscheers" > /app/spotweb/package_info && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config