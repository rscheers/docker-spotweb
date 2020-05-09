#FROM lsiobase/ubuntu:arm32v7-bionic
FROM rwscheers/raspbian-buster

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SPOTWEB_RELEASE
LABEL build_version="rwscheers version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="rwscheers"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV SPOTWEB_RELEASE_TYPE="Release"

RUN     apt-get update
RUN     apt-get install -y apt-utils
RUN     apt-get install -y git nginx mariadb-common php7.3-fpm php7.3-gd
 
RUN		sed -i 's,;extension=pdo_mysql,extension=pdo_mysql,g'  /etc/php/7.3/cli/php.ini
RUN 	sed -i 's,;extension=mysql,extension=mysql,g'  /etc/php/7.3/cli/php.ini
RUN 	sed -i 's,;extension=gettext,extension=gettext,g'  /etc/php/7.3/cli/php.ini
RUN		sed -i 's,;extension=gd,extension=gd,g'  /etc/php/7.3/cli/php.ini
RUN		sed -i 's,;extension=zip,extension=zip,g'  /etc/php/7.3/cli/php.ini
RUN		sed -i 's,;extension=openssl.so,extension=openssl.so,g'  /etc/php/7.3/cli/php.ini
RUN		sed -i "s,;date.timezone =.*,date.timezone = Europe/Amsterdam,g"  /etc/php/7.3/cli/php.ini
RUN		sed -i "s,memory_limit = 128M,memory_limit = 512M,g"  /etc/php/7.3/cli/php.ini

RUN		git clone https://github.com/spotweb/spotweb.git /var/www/spotweb
RUN		mkdir /var/www/spotweb/cache
RUN		chmod 777 /var/www/spotweb/cache

ADD		dbsettings.inc.php /var/www/spotweb/dbsettings.inc.php
RUN		chown -R www-data:www-data /var/www

ADD		./create-mysql-structure.sh /opt/create-mysql-structure.sh
RUN		chmod +x /opt/create-mysql-structure.sh

#ADD		nginx.conf /etc/nginx/nginx.conf
ADD		spotweb.conf /etc/nginx/sites-enabled/spotweb.conf

# RUN     mkdir -p /app/spotweb 
# RUN     echo "ReleaseType=${SPOTWEB_RELEASE_TYPE}\nPackageVersion=${VERSION}\nPackageAuthor=rwscheers" > /app/spotweb/package_info
RUN     rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# ports and volumes
EXPOSE 80
VOLUME /var/lib/mysql