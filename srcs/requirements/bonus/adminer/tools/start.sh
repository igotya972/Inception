#!/bin/sh

echo "Démarrage du serveur PHP pour Adminer..."
php -S 0.0.0.0:8080 -t /var/www/html
