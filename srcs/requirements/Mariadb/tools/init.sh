#!/bin/sh

# Lire les secrets
if [ -f "/run/secrets/db_root_password" ]; then
    ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
else
    echo "Erreur: Fichier db_root_password non trouvé"
    exit 1
fi

if [ -f "/run/secrets/db_password" ]; then
    WP_DB_PASSWORD=$(cat /run/secrets/db_password)
else
    echo "Erreur: Fichier db_password non trouvé"
    exit 1
fi

# Définir les autres variables
WP_DB_USER="wordpress"
WP_DB_NAME="wordpress"

# Créer le répertoire pour le socket MySQL et définir les permissions
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

# Vérifier si la base de données est déjà initialisée
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Vérifier si le mot de passe root est déjà défini et si la base existe
if [ ! -f "/var/lib/mysql/.root_password_set" ] && [ ! -d "/var/lib/mysql/${WP_DB_NAME}" ]; then
    echo "Démarrage temporaire de MariaDB..."
    mysqld_safe --user=mysql --skip-networking --datadir=/var/lib/mysql &

    # Attendre que le serveur soit prêt
    echo "Attente du démarrage de MariaDB..."
    until mysqladmin ping --silent; do
        sleep 2
    done

    mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
	EOSQL

    mysql -u root -p"${ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME}\`;

        DROP USER IF EXISTS '${WP_DB_USER}'@'%';
        CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${WP_DB_NAME}\`.* TO '${WP_DB_USER}'@'%';

	EOSQL

	touch /var/lib/mysql/.root_password_set
	echo "Arrêt de MariaDB..."
	mysqladmin shutdown --user=root --password="${ROOT_PASSWORD}"
	sleep 2
fi

echo "Démarrage final de MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql