#!/bin/sh

# Attendre que MariaDB soit prêt
while ! mariadb -h$MYSQL_HOSTNAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" >/dev/null 2>&1; do
    echo "En attente de la connexion à MariaDB..."
    sleep 3
done

# Augmenter la limite de mémoire PHP
echo "memory_limit = 256M" > /etc/php81/conf.d/memory.ini

# Vérifier si WordPress est déjà installé
if [ ! -f wp-config.php ]; then
    echo "Installation de WordPress..."
    
    # Télécharger WordPress
    wp core download --locale=fr_FR --allow-root
    
    # Créer le fichier de configuration
    wp config create --dbname=$MYSQL_DATABASE \
                     --dbuser=$MYSQL_USER \
                     --dbpass=$MYSQL_PASSWORD \
                     --dbhost=$MYSQL_HOSTNAME \
                     --allow-root
    
    # Installer WordPress
    wp core install --url=https://$WORDPRESS_HOST \
                   --title="Inception" \
                   --admin_user=$WP_ADMIN_USER \
                   --admin_password=$WP_ADMIN_PASSWORD \
                   --admin_email=$WP_ADMIN_EMAIL \
                   --allow-root
    
    # Créer un utilisateur supplémentaire
    wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --allow-root
    
    echo "WordPress installé avec succès!"
else
    echo "WordPress est déjà installé."
fi

# Démarrer PHP-FPM en premier plan
exec php-fpm81 -F 