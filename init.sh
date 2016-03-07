#!/bin/bash

if [ ! -d "/var/www/phpci/public/" ]; then
	cd /var/www/
	/usr/local/bin/composer create-project block8/phpci phpci --keep-vcs --no-dev && \
		cd phpci && \
		/usr/local/bin/composer install && \
		/usr/local/bin/composer require sebastian/phpcpd 2.0.2
	cp /var/www/config.yml /var/www/phpci/PHPCI/config.yml
	cp /var/www/local_vars.php /var/www/phpci/local_vars.php
	mv /var/www/phpci/public/.htaccess.dist /var/www/phpci/public/.htaccess
	chown -R www-data: /var/www/
fi
