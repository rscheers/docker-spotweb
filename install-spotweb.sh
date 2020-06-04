#!/bin/bash -ex
apt-get update
apt-get install -y dialog apt-utils
apt-get install -y git nginx php7.3-fpm php7.3-gd
 
sed -i 's,;extension=pdo_mysql,extension=pdo_mysql,g'  /etc/php/7.3/cli/php.ini
sed -i 's,;extension=mysql,extension=mysql,g'  /etc/php/7.3/cli/php.ini
sed -i 's,;extension=gettext,extension=gettext,g'  /etc/php/7.3/cli/php.ini
sed -i 's,;extension=gd,extension=gd,g'  /etc/php/7.3/cli/php.ini
sed -i 's,;extension=zip,extension=zip,g'  /etc/php/7.3/cli/php.ini
sed -i 's,;extension=openssl.so,extension=openssl.so,g'  /etc/php/7.3/cli/php.ini
sed -i "s,;date.timezone =.*,date.timezone = Europe/Amsterdam,g"  /etc/php/7.3/cli/php.ini
sed -i "s,memory_limit = 128M,memory_limit = 512M,g"  /etc/php/7.3/cli/php.ini

git clone https://github.com/spotweb/spotweb.git /var/www/spotweb
mkdir /var/www/spotweb/cache
chmod 777 /var/www/spotweb/cache