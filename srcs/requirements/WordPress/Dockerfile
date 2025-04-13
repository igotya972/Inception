FROM alpine:3.19

RUN apk update && apk add --no-cache \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-json \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-mbstring \
    php81-openssl \
    php81-xml \
    php81-zip \
    php81-phar \
    curl \
    mariadb-client

# PHP-FPM config
RUN mkdir -p /run/php
COPY conf/www.conf /etc/php81/php-fpm.d/www.conf

# WP-CLI installation
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# WordPress directory
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Installation script
COPY tools/wp-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-setup.sh

EXPOSE 9000

CMD ["/usr/local/bin/wp-setup.sh"] 