FROM php:5-apache

RUN apt-get update && apt-get install -y \
        git \
        vim \
        libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev
RUN rm -rfv /var/lib/apt/lists/*

COPY php.ini.example /usr/local/etc/php/php.ini

RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include
RUN docker-php-ext-configure bcmath
RUN docker-php-ext-install gd opcache mysql mysqli bcmath
RUN docker-php-ext-enable opcache bcmath mysqli

RUN mkdir /sourcebans
WORKDIR /sourcebans

COPY . /sourcebans
RUN cp -rv web_upload/* /var/www/html/ && chown -R www-data:www-data /var/www/html/
COPY config.php.docker /var/www/html/config.php
RUN rm -rf /var/www/html/install /var/www/html/updater
