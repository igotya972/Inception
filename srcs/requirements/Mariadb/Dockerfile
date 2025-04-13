FROM alpine:3.19

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    chmod 777 /var/lib/mysql && \
    chmod 755 /run/mysqld

EXPOSE 3306

COPY conf/my.cnf /etc/my.cnf
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]