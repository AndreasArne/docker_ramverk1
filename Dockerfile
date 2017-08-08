FROM php:7.1.8-apache

# install composer
RUN 	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
	php composer-setup.php && \
	php -r "unlink('composer-setup.php');" && \
	install --mode=0755 composer.phar /usr/local/bin/composer && \
	rm composer.phar

# install phpuit 6.3.0
RUN	curl https://phar.phpunit.de/phpunit-6.3.0.phar -o phpunit && chmod 755 phpunit && \
	cp phpunit /usr/local/bin && \
	rm phpunit

RUN	apt-get -qq update && apt-get install -qy wget

# install xdbug 2.5.4
RUN	wget http://xdebug.org/files/xdebug-2.5.4.tgz && \
	tar -xvzf xdebug-2.5.4.tgz && \
	cd xdebug-2.5.4 && \
	phpize && \
	./configure && \
	make && \
	cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303 && \
	echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" > /usr/local/etc/php/php.ini && \
	rm -rf xdebu*

EXPOSE 80

VOLUME ["/var/www/html"]


# Möljlig lösning för "could not determin server domain name"
# echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn
