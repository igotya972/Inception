# Projet Inception

![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)
![Nginx](https://img.shields.io/badge/Nginx-Alpine-green)
![MariaDB](https://img.shields.io/badge/MariaDB-10.11-orange)
![WordPress](https://img.shields.io/badge/WordPress-6.4-blue)

Ce projet consiste à créer une infrastructure de développement utilisant Docker et docker-compose, comprenant trois services principaux (NGINX, WordPress et MariaDB) et des services bonus.

## Architecture

Le projet suit une architecture en conteneurs avec les services suivants :

- **NGINX** : Serveur web avec TLS 1.3
- **WordPress** : CMS avec PHP-FPM
- **MariaDB** : Base de données SQL
- **Adminer** : Interface d'administration de base de données (bonus)

Chaque service s'exécute dans son propre conteneur Docker basé sur Alpine Linux.

## Prérequis

- Docker 20.10+
- Docker Compose
- Make

## Installation et démarrage

1. Cloner le dépôt
   ```bash
   git clone <url_du_repo> Inception
   cd Inception
   ```

2. Configurer le nom d'hôte (dans `/etc/hosts`)
   ```bash
   sudo echo "127.0.0.1 <votre_domaine>" >> /etc/hosts
   ```

3. Démarrer l'infrastructure
   ```bash
   make re
   ```

## Commandes principales

Le projet utilise un Makefile pour faciliter les opérations :

| Commande | Description |
|----------|-------------|
| `make all` | Prépare les volumes et lance les conteneurs |
| `make up` | Démarre les conteneurs |
| `make down` | Arrête les conteneurs |
| `make clean` | Arrête les conteneurs et supprime les volumes Docker |
| `make fclean` | Supprime tout (conteneurs, images, volumes) |
| `make re` | Reconstruit complètement l'infrastructure |
| `make logs` | Affiche les logs des conteneurs |
| `make status` | Affiche l'état des conteneurs |

## Captures d'écran et démonstration

### État des conteneurs

Voici l'état des conteneurs après démarrage :

```
NAMES       STATUS          PORTS
nginx       Up 14 minutes   0.0.0.0:443->443/tcp, [::]:443->443/tcp
wordpress   Up 14 minutes   9000/tcp
adminer     Up 14 minutes   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
mariadb     Up 14 minutes   3306/tcp
```

### Bases de données

Bases de données disponibles sur le serveur MariaDB :

```
+--------------------+
| Database           |
+--------------------+
| inception          |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test               |
+--------------------+
```

### Tables WordPress

Structure de la base de données WordPress :

```
+-----------------------+
| Tables_in_inception   |
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
```

### Utilisateurs WordPress

Utilisateurs créés dans WordPress :

```
*************************** 1. row ***************************
                 ID: 1
         user_login: wp_admin
          user_pass: **********
      user_nicename: wp_admin
         user_email: admin@example.com
           user_url: https://example.com
    user_registered: YYYY-MM-DD HH:MM:SS
user_activation_key: 
        user_status: 0
       display_name: WordPress Admin
*************************** 2. row ***************************
                 ID: 2
         user_login: wp_user
          user_pass: **********
      user_nicename: wp_user
         user_email: user@example.com
           user_url: 
    user_registered: YYYY-MM-DD HH:MM:SS
user_activation_key: 
        user_status: 0
       display_name: WordPress User
```

### Adresses IP des conteneurs

Configuration réseau des conteneurs :

```
172.18.0.2  # mariadb
172.18.0.4  # wordpress
172.18.0.5  # nginx
172.18.0.3  # adminer
```

### Volumes Docker

Volumes persistants créés par Docker Compose :

```
DRIVER    VOLUME NAME
local     srcs_mariadb
local     srcs_wordpress
```

## Accès aux services

| Service | URL | Identifiants |
|---------|-----|--------------|
| WordPress | https://\<votre_domaine\> | Login: *******<br>Password: ******* |
| Adminer | http://localhost:8080 | Serveur: mariadb<br>Utilisateur: *******<br>Mot de passe: *******<br>Base de données: inception |

## Commandes utiles

### Connexion à la base de données

```bash
# Voir les bases de données
docker exec -it mariadb mariadb -u<utilisateur> -p'<mot_de_passe>' -e "SHOW DATABASES;"

# Mode interactif
docker exec -it mariadb mariadb -u<utilisateur> -p'<mot_de_passe>'

# Afficher les tables WordPress
docker exec -it mariadb mariadb -u<utilisateur> -p'<mot_de_passe>' -e "USE inception; SHOW TABLES;"

# Afficher les utilisateurs WordPress
docker exec -it mariadb mariadb -u<utilisateur> -p'<mot_de_passe>' -e "USE inception; SELECT user_login, user_email FROM wp_users;"
```

### Suivi des logs

```bash
# Tous les logs
make logs

# Logs de WordPress
docker logs wordpress

# Logs de MariaDB
docker logs mariadb

# Logs de Nginx
docker logs nginx

# Logs d'Adminer
docker logs adminer
```

## Structure du projet

```
Inception/
├── Makefile                   # Commandes pour la gestion du projet
├── srcs/
│   ├── docker-compose.yml     # Configuration des services
│   ├── .env                   # Variables d'environnement
│   └── requirements/
│       ├── nginx/             # Configuration du serveur web
│       ├── WordPress/         # Configuration de WordPress
│       ├── Mariadb/           # Configuration de la base de données
│       └── bonus/
│           └── adminer/       # Service bonus d'administration DB
└── secrets/                   # Secrets Docker pour les mots de passe
```

## Volumes persistants

Les données sont stockées dans des volumes persistants :

- `mariadb` : Stockage des données de la base MariaDB
- `wordpress` : Stockage des fichiers WordPress

## Sécurité

- Utilisation de TLS 1.3 pour NGINX
- Mots de passe gérés via Docker Secrets
- Réseau dédié entre les conteneurs

## Notes techniques

- Tous les conteneurs sont basés sur Alpine Linux
- Les services sont configurés pour redémarrer automatiquement sauf en cas d'arrêt manuel
- L'accès à WordPress se fait exclusivement via HTTPS 