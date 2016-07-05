#!/bin/bash

if [ -d "/var/www/phpci/public/" ]; then
	cd /var/www/phpci/
	VERSION=`git status|grep HEAD|awk '{print $4}'`
	if [ "$PHPCI_VERSION" != "$VERSION" ]; then
		echo "Need to be upgrade"
		cd /var/www/
		rm -rf /var/www/phpci/*
	fi
fi

if [ ! -d "/var/www/phpci/public/" ]; then
	cd /var/www/
	/usr/local/bin/composer create-project block8/phpci=$PHPCI_VERSION phpci --keep-vcs --no-dev && \
		cd phpci && \
		/usr/local/bin/composer install && \
		/usr/local/bin/composer require sebastian/phpcpd 2.0.2
	php ./console phpci:install --queue-disabled --url=$PHPCI_URL --db-host=$MYSQL_SERVER --db-name=$MYSQL_BDD --db-user=$MYSQL_USER --db-pass=$MYSQL_PASSWORD --admin-name=$ADMIN_NAME --admin-pass=$ADMIN_PASS --admin-mail=$ADMIN_MAIL
	cp /var/www/local_vars.php /var/www/phpci/local_vars.php
	cp /var/www/phpci/public/.htaccess.dist /var/www/phpci/public/.htaccess
	chown -R www-data: /var/www/
fi
