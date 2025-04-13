#!/bin/sh

[ ! -e /usr/bin/php ] && ln -sf /usr/bin/php81 /usr/bin/php

MAX_TRY=5
CURRENT_TRY=0

echo "Connexion à MariaDB..."
while ! mariadb -h$MYSQL_HOSTNAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" >/dev/null 2>&1; do
    CURRENT_TRY=$((CURRENT_TRY+1))
    if [ $CURRENT_TRY -ge $MAX_TRY ]; then
        echo "Échec de connexion à MariaDB après $MAX_TRY tentatives."
        exit 1
    fi
    sleep 2
done

if [ ! -f wp-config.php ]; then
    echo "Installation de WordPress..."
    
    if [ ! -f /tmp/wordpress.tar.gz ]; then
        wp core download --locale=fr_FR --allow-root --force --quiet
    else
        echo "Utilisation du cache WordPress"
        tar -xzf /tmp/wordpress.tar.gz -C /var/www/html
    fi
    
    wp config create --dbname=$MYSQL_DATABASE \
                    --dbuser=$MYSQL_USER \
                    --dbpass=$MYSQL_PASSWORD \
                    --dbhost=$MYSQL_HOSTNAME \
                    --allow-root \
                    --skip-check \
                    --quiet
    
    wp core install --url=https://$WORDPRESS_HOST \
                   --title="Inception" \
                   --admin_user=$WP_ADMIN_USER \
                   --admin_password=$WP_ADMIN_PASSWORD \
                   --admin_email=$WP_ADMIN_EMAIL \
                   --allow-root \
                   --skip-email
    
    wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --allow-root --quiet
    
    wp plugin delete hello akismet --allow-root --quiet
    
    echo "WordPress installé"
else
    echo "WordPress déjà installé"
fi

chown -R nobody:nobody /var/www/html
chmod -R 755 /var/www/html

exec php-fpm81 -F 