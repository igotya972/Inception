# Variables
NGINX_IMAGE_NAME = nginx-tls
NGINX_CONTAINER_NAME = nginx-container
DOCKERFILE_PATH = srcs/requirements/nginx/
NGINX_CONF_PATH = srcs/requirements/nginx/conf/

# Couleurs pour les messages
GREEN = \033[0;32m
RESET = \033[0m

# Règles principales
all: build run

# Construit l'image NGINX
build:
	@echo "$(GREEN)Construction de l'image $(NGINX_IMAGE_NAME)...$(RESET)"
	docker build -t $(NGINX_IMAGE_NAME) $(DOCKERFILE_PATH)

# Lance le conteneur NGINX
run:
	@echo "$(GREEN)Démarrage du conteneur $(NGINX_CONTAINER_NAME)...$(RESET)"
	-docker stop $(NGINX_CONTAINER_NAME) 2>/dev/null || true
	-docker rm $(NGINX_CONTAINER_NAME) 2>/dev/null || true
	docker run -d -p 443:443 --name $(NGINX_CONTAINER_NAME) $(NGINX_IMAGE_NAME)

# Arrête et supprime le conteneur
stop:
	@echo "$(GREEN)Arrêt du conteneur $(NGINX_CONTAINER_NAME)...$(RESET)"
	-docker stop $(NGINX_CONTAINER_NAME)
	-docker rm $(NGINX_CONTAINER_NAME)

# Supprime le conteneur et l'image
clean: stop
	@echo "$(GREEN)Suppression de l'image $(NGINX_IMAGE_NAME)...$(RESET)"
	-docker rmi $(NGINX_IMAGE_NAME)

# Redémarre le conteneur
restart: stop run

# Affiche les logs du conteneur
logs:
	docker logs -f $(NGINX_CONTAINER_NAME)

# Accède au shell du conteneur
shell:
	docker exec -it $(NGINX_CONTAINER_NAME) /bin/sh

# Règle pour reconstruire complètement
re: clean all

# Règle pour afficher l'état
status:
	@echo "$(GREEN)Images Docker:$(RESET)"
	docker images | grep $(NGINX_IMAGE_NAME) || echo "Aucune image $(NGINX_IMAGE_NAME) trouvée"
	@echo "\n$(GREEN)Conteneurs en cours d'exécution:$(RESET)"
	docker ps | grep $(NGINX_CONTAINER_NAME) || echo "Aucun conteneur $(NGINX_CONTAINER_NAME) en cours d'exécution"

.PHONY: all build run stop clean restart logs shell re status
