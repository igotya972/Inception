FROM alpine:3.18

# Installation des paquets nécessaires
RUN apk update && apk add --no-cache mariadb mariadb-client

# Configuration des permissions
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    chmod 777 /var/lib/mysql && \
    chmod 755 /run/mysqld

# Exposer le port 3306
EXPOSE 3306

# Copie de la configuration
COPY conf/my.cnf /etc/my.cnf
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]