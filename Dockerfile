# All rights reserved © 2018 Zero
FROM php:apache
MAINTAINER Mohos Tamas <tomi@mohos.name>

ENV DEBIAN_FRONTEND="noninteractive"

# update and install required packages
RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y git curl cron zlib1g-dev libicu-dev g++ supervisor rsyslog nano locales locales-all libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure intl \
    && docker-php-ext-install soap zip intl gettext mysqli pdo_mysql opcache \
    && docker-php-ext-enable opcache

# Config
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Budapest /etc/localtime \
    && echo "Europe/Budapest" > /etc/timezone \
    && echo "log_errors = On" >> /usr/local/etc/php/php.ini \
    && echo "error_log = /dev/stderr" >> /usr/local/etc/php/php.ini \
    && echo "date.timezone = 'Europe/Budapest'" >> /usr/local/etc/php/php.ini \
    && echo "upload_max_filesize = 100M" >> /usr/local/etc/php/php.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/php.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf
    
# Define workspace
WORKDIR /var/www/html
