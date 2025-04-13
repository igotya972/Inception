COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env
VOL_WWW = /home/dferjul/data/wordpress
VOL_DB = /home/dferjul/data/mariadb

GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
RESET = \033[0m

all: prepare up

prepare:
	@echo "$(GREEN)Préparation des volumes...$(RESET)"
	@mkdir -p $(VOL_DB) $(VOL_WWW)
	@sudo chmod 755 $(VOL_WWW)
	@sudo chmod 750 $(VOL_DB)

up:
	@echo "$(GREEN)Construction et démarrage...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@docker compose -f $(COMPOSE_FILE) down

clean: down
	@docker compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@docker system prune -af
	@sudo rm -rf $(VOL_DB) $(VOL_WWW)

restart: down up

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

re: fclean all

status:
	@docker compose -f $(COMPOSE_FILE) ps

nginx:
	@docker compose -f $(COMPOSE_FILE) up -d --build nginx

mariadb:
	@docker compose -f $(COMPOSE_FILE) up -d --build mariadb

wordpress:
	@docker compose -f $(COMPOSE_FILE) up -d --build wordpress

.PHONY: all prepare up down clean fclean restart logs re status nginx mariadb wordpress
