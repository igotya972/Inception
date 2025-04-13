COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
RESET = \033[0m

all: prepare up

prepare:
	@echo "$(GREEN)Préparation de l'environnement...$(RESET)"
	@mkdir -p $(shell grep MARIADB_VOLUME_PATH $(ENV_FILE) | cut -d '=' -f2)
	@mkdir -p $(shell grep WORDPRESS_VOLUME_PATH $(ENV_FILE) | cut -d '=' -f2)
	@mkdir -p $(shell grep VOL_WWW $(ENV_FILE) | cut -d '=' -f2)
	@echo "$(GREEN)Répertoires de volumes créés avec succès$(RESET)"

up:
	@echo "$(GREEN)Construction et démarrage des services...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "$(YELLOW)Arrêt des services...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down

clean: down
	@echo "$(YELLOW)Suppression des volumes...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@echo "$(RED)Suppression des images...$(RESET)"
	@docker system prune -af

restart: down up

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

re: fclean all

status:
	@echo "$(GREEN)Services en cours d'exécution:$(RESET)"
	@docker compose -f $(COMPOSE_FILE) ps

nginx:
	@echo "$(GREEN)Construction et démarrage de NGINX...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d --build nginx

mariadb:
	@echo "$(GREEN)Construction et démarrage de MariaDB...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d --build mariadb

wordpress:
	@echo "$(GREEN)Construction et démarrage de WordPress...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d --build wordpress

.PHONY: all prepare up down clean fclean restart logs re status nginx mariadb wordpress
