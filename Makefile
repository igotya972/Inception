# Variables
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

# Couleurs pour les messages
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
RESET = \033[0m

# Règles principales
all: prepare up

# Prépare l'environnement
prepare:
	@echo "$(GREEN)Préparation de l'environnement...$(RESET)"
	@mkdir -p $(shell grep MARIADB_VOLUME_PATH $(ENV_FILE) | cut -d '=' -f2)
	@mkdir -p $(shell grep WORDPRESS_VOLUME_PATH $(ENV_FILE) | cut -d '=' -f2)

# Construit et démarre les services
up:
	@echo "$(GREEN)Construction et démarrage des services...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d --build

# Arrête les services
down:
	@echo "$(YELLOW)Arrêt des services...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down

# Arrête et supprime les volumes
clean: down
	@echo "$(YELLOW)Suppression des volumes...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down -v

# Supprime tout, y compris les images
fclean: clean
	@echo "$(RED)Suppression des images...$(RESET)"
	@docker system prune -af

# Redémarre les services
restart: down up

# Affiche les logs
logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

# Règle pour reconstruire complètement
re: fclean all

# Règle pour afficher l'état des services
status:
	@echo "$(GREEN)Services en cours d'exécution:$(RESET)"
	@docker compose -f $(COMPOSE_FILE) ps

.PHONY: all prepare up down clean fclean restart logs re status
