# Projet Inception

![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)
![Nginx](https://img.shields.io/badge/Nginx-Alpine-green)
![MariaDB](https://img.shields.io/badge/MariaDB-10.11-orange)
![WordPress](https://img.shields.io/badge/WordPress-6.4-blue)

## Architecture

- **NGINX** : Serveur web avec TLS v1.2/v1.3
- **WordPress** : CMS avec PHP-FPM
- **MariaDB** : Base de données SQL
- **Adminer** : Interface d'administration de base de données (bonus)

Chaque service s'exécute dans son propre conteneur Docker basé sur Alpine Linux.

## Installation et démarrage

1. Cloner le dépôt
   ```bash
   git clone https://github.com/dferjul/Inception.git
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

### État des conteneurs

Conteneurs après démarrage :

```
NAMES       STATUS          PORTS
nginx       Up 14 minutes   0.0.0.0:443->443/tcp, [::]:443->443/tcp
wordpress   Up 14 minutes   9000/tcp
adminer     Up 14 minutes   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
mariadb     Up 14 minutes   3306/tcp
```

### Bases de données

Pour afficher les bases de données :
```bash
docker exec -it mariadb mariadb -u<utilisateur> -p'<mot_de_passe>' -e "SHOW DATABASES;"
```

Résultat :

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

Pour afficher les tables WordPress :
```bash
docker exec -it mariadb mariadb -u<utilisateur> -p'<mot_de_passe>' -e "USE inception; SHOW TABLES;"
```

Résultat :

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

Pour afficher les utilisateurs WordPress :
```bash
docker exec -it mariadb mariadb -u<utilisateur> -p'<mot_de_passe>' -e "USE inception; SELECT * FROM wp_users;"
```

Résultat :

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

```
172.18.0.2  # mariadb
172.18.0.4  # wordpress
172.18.0.5  # nginx
172.18.0.3  # adminer
```

### Volumes Docker

Volumes persistants :

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