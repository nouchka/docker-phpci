FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install git apache2 libapache2-mod-php5 php5 php5-cli php5-curl php5-mysql php5-intl php5-mcrypt curl npm && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##Bower
##RUN apt-get -yf install npm
RUN ln -s /usr/bin/nodejs /usr/bin/node
##RUN npm install -g bower

##Tools
RUN npm install -g less && \
	npm install -g uglify-js && \
	npm install -g uglifycss && \
	npm install -g bower

##Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	php /usr/local/bin/composer self-update

##Apache
RUN a2enmod rewrite
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
COPY phpci.conf /etc/apache2/sites-available/phpci.conf
RUN a2ensite phpci
RUN a2dissite 000-default

##PHP date.timezone
RUN echo "date.timezone = UTC" >> /etc/php5/cli/php.ini
RUN echo "date.timezone = UTC" >> /etc/php5/apache2/php.ini

##PHPCI
WORKDIR /var/www/
##RUN /usr/local/bin/composer create-project block8/phpci phpci --keep-vcs --no-dev && \
##	cd phpci && \
##	/usr/local/bin/composer install && \
##	/usr/local/bin/composer require sebastian/phpcpd 2.0.2
##COPY config.yml /var/www/phpci/PHPCI/config.yml
##COPY local_vars.php /var/www/phpci/local_vars.php
COPY config.yml /var/www/config.yml
COPY local_vars.php /var/www/local_vars.php
##RUN mv /var/www/phpci/public/.htaccess.dist /var/www/phpci/public/.htaccess
##	/usr/local/bin/composer install && \
##	./console phpci:install

##SSH keys
##RUN mkdir -p /var/www/.ssh
##RUN ssh-keyscan subversion.sdsix.lan >> /var/www/.ssh/known_hosts
##COPY id_rsa /var/www/.ssh/id_rsa
##RUN chmod 600 /var/www/.ssh/id_rsa
##RUN chsh -s /bin/bash www-data

COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY cron.sh /cron.sh
RUN chmod +x /cron.sh
COPY init.sh /init.sh
RUN chmod +x /init.sh
RUN chown -R www-data: /var/www/

VOLUME ["/var/log"]

CMD ["/bin/bash", "-e", "/start.sh"]
