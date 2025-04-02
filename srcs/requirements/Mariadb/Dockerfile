FROM alpine:3.18

# Installation des paquets nécessaires
RUN apk update && apk add --no-cache mariadb mariadb-client

# Création des répertoires
RUN mkdir -p /run/mysql /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql && \
    chmod 777 /var/lib/mysql
# Exposer le port 3306
EXPOSE 3306

# Copie de la configuration
COPY conf/my.cnf /etc/my.cnf
COPY tools/init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh

ENTRYPOINT ["/tmp/init.sh"]