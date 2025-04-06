#!/bin/sh

# Toujours initialiser les tables système
mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

# Vérifier si l'initialisation a déjà été faite
if [ ! -f "/var/lib/mysql/.initialized" ]; then
    # Démarrage temporaire pour configuration
    mysqld --datadir=/var/lib/mysql --skip-networking --user=mysql &
    until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do sleep 1; done

    # Configuration
    mysql --protocol=socket --socket=/run/mysqld/mysqld.sock << EOF
CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'dam';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';
FLUSH PRIVILEGES;
EOF

    mysqladmin --socket=/run/mysqld/mysqld.sock shutdown
    # Marquer comme initialisé
    touch /var/lib/mysql/.initialized
fi

# Démarrage final
exec mysqld --user=mysql