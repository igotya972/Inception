FROM alpine:3.19

# Installation des paquets nécessaires
RUN apk update && apk add --no-cache nginx openssl

# Création des répertoires
RUN mkdir -p /run/nginx /etc/nginx/ssl /var/www/html

# Génération du certificat SSL auto-signé
RUN openssl req -x509 -nodes \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=IDF/L=Nice/O=42/CN=dferjul.42.fr"

# Copie de la configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Exposer le port HTTPS
EXPOSE 443

# Démarrer Nginx en premier plan
CMD ["nginx", "-g", "daemon off;"]

# Créer un fichier index.html dans le conteneur
RUN echo "<h1>NGINX fonctionne avec TLS !</h1>" > /var/www/html/index.html