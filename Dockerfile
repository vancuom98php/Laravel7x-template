FROM php:7.4.1-apache

ENV HOST_USER_ID 501
ENV HOST_GROUP_ID 20

#install all the system dependencies and enable PHP modules 
RUN apt-get update && apt-get install -y \
      libicu-dev \
      libpq-dev \
      libmcrypt-dev \
      libonig-dev \
      libzip-dev \
      git \
      zip \
      unzip \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      intl \
      mbstring \
      pcntl \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      zip \
      opcache

#install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
#install node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
      && apt-get install -y nodejs

COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint

#set our application folder as an environment variable
ENV APP_HOME /var/www/html

#change uid and gid of apache to docker user uid/gid
# RUN usermod -u $HOST_USER_ID www-data && groupmod -g $HOST_GROUP_ID www-data

#change the web_root to laravel /var/www/html/public folder
RUN sed -i -e "s/html/html\/public/g" /etc/apache2/sites-enabled/000-default.conf

# enable apache module rewrite
RUN a2enmod rewrite

#copy source files and run composer
VOLUME [ "/var/www/html" ]

# install all PHP dependencies
#RUN composer install --no-interaction

