#!/bin/bash

/init.sh
sed -i \
    -e "s|\$MYSQL_SERVER|$MYSQL_SERVER|g" \
    -e "s|\$MYSQL_BDD|$MYSQL_BDD|g" \
    -e "s|\$MYSQL_USER|$MYSQL_USER|g" \
    -e "s|\$MYSQL_PASSWORD|$MYSQL_PASSWORD|g" \
    -e "s|\$PHPCI_URL|$PHPCI_URL|g" \
    /var/www/phpci/PHPCI/config.yml

chown www-data: /var/www/phpci/PHPCI/config.yml

cd /var/www/phpci/
composer update
php console phpci:update

/usr/sbin/apache2 -D FOREGROUND
