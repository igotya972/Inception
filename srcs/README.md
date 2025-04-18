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

## Prérequis
- Docker
- Docker Compose

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
  Remplace `wordpress` par le conteneur désiré.

## Conseils & Astuces
- Consultez les logs en cas d'erreur (`make logs` ou `docker-compose logs <service>`).
- Pour réinitialiser complètement l'environnement, utilisez `make fclean`.
