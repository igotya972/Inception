# Inception

## Structure du projet
```
Inception/
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── Mariadb/
        ├── nginx/
        ├── WordPress/
        └── bonus/
```

## Commandes Makefile principales

- **Tout construire et lancer** :
  ```bash
  make
  # ou
  make all
  ```
- **Arrêter les services** :
  ```bash
  make down
  ```
- **Nettoyer (supprime les volumes)** :
  ```bash
  make clean
  ```
- **Nettoyage complet (volumes + images + dossiers data)** :
  ```bash
  make fclean
  ```
- **Redémarrer tous les services** :
  ```bash
  make restart
  ```
- **Voir les logs** :
  ```bash
  make logs
  ```
- **Status des conteneurs** :
  ```bash
  make status
  ```
- **Lancer un service spécifique** :
  ```bash
  make nginx
  make mariadb
  make wordpress
  make adminer
  ```
- **Lancer les bonus** :
  ```bash
  make bonus
  ```

## Accéder à l'intérieur d'un conteneur

- **Lister les conteneurs actifs** :
  ```bash
  docker ps
  ```
- **Ouvrir un shell dans un conteneur** (exemple pour WordPress) :
  ```bash
  docker exec -it wordpress sh
  ```
# Afficher les données de la base de données
  ```bash
  docker exec -it mariadb mysql -u $DB_USER -p$DB_PASSWORD -e "SELECT * FROM $DB_NAME.wp_users;"
  ```

## Afficher les utilisateurs WordPress dans la base de données

Pour vérifier la présence des utilisateurs WordPress créés automatiquement :

```bash
docker exec -it mariadb mysql -u root -pdamroot -D inception -e "SELECT ID, user_login, user_email FROM wp_users;"
```

Résultat :

```
+----+------------+-------------------+
| ID | user_login | user_email        |
+----+------------+-------------------+
|  1 | dferjul    | dferjul@42nice.fr |
|  2 | hood       | hood@42nice.fr    |
+----+------------+-------------------+
```

