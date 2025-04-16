FROM alpine:3.19

RUN apk update && apk add --no-cache \
    php82 \
    php82-mysqli \
    php82-json \
    php82-session \
    php82-pdo \
    php82-pdo_mysql \
    php82-curl \
    wget

# Configuration
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Télécharger Adminer
RUN wget -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    chmod 755 /var/www/html/index.php

# Script de démarrage
COPY tools/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"] 