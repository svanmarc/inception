# ============================
# Définitions des couleurs
# ============================
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m

# ============================
# Chemin vers le fichier .env
# ============================
ENV_FILE=./srcs/.env

# ============================
# Chargement des variables .env
# ============================
ifneq (,$(wildcard $(ENV_FILE)))
    include $(ENV_FILE)
    export $(shell sed 's/=.*//' $(ENV_FILE))
endif

# ============================
# Variables de configuration
# ============================
DOCKER_COMPOSE_FILE=./srcs/docker-compose.yml

# ============================
# Cibles principales
# ============================
.PHONY: all build up down stop clean fclean re status help

all: build up

build:
	@echo "$(GREEN)Construction des images Docker...$(NC)"
	@docker compose -f $(DOCKER_COMPOSE_FILE) build

up:
	@echo "$(GREEN)Démarrage des conteneurs...$(NC)"
	@mkdir -p $(WORDPRESS_VOLUME) $(MARIADB_VOLUME)
	@sudo chmod -R 755 $(WORDPRESS_VOLUME) $(MARIADB_VOLUME)
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	@echo "$(YELLOW)Arrêt et suppression des conteneurs, réseaux, etc...$(NC)"
	@docker compose -f $(DOCKER_COMPOSE_FILE) down

stop:
	@echo "$(RED)Arrêt de tous les conteneurs en cours...$(NC)"
	@containers=$$(docker ps -q); \
	if [ -n "$$containers" ]; then \
		docker stop $$containers || true; \
	else \
		echo "$(YELLOW)Aucun conteneur en cours d'exécution à arrêter.$(NC)"; \
	fi

re: down all
	@echo "$(BLUE)Reconstruction et redémarrage des conteneurs...$(NC)"

clean: stop
	@echo "$(RED)Suppression des conteneurs, images pendantes, réseaux et nettoyage système...$(NC)"
	@containers=$$(docker ps -qa); \
	if [ -n "$$containers" ]; then \
		docker rm -f $$containers || true; \
	else \
		echo "$(YELLOW)Aucun conteneur à supprimer.$(NC)"; \
	fi
	@images=$$(docker images -qa --filter "dangling=true"); \
	if [ -n "$$images" ]; then \
		docker rmi -f $$images || true; \
	else \
		echo "$(YELLOW)Aucune image pendante à supprimer.$(NC)"; \
	fi
	@docker network prune -f || true
	@docker system prune -a -f || true

fclean: clean
	@read -p "Êtes-vous sûr de vouloir supprimer tous les volumes et données persistantes ? [y/N]: " confirm && \
	if [ "$$confirm" = "y" ]; then \
		echo "$(RED)Suppression des volumes et des répertoires de données persistantes...$(NC)"; \
		volumes=$$(docker volume ls -q); \
		if [ -n "$$volumes" ]; then \
			docker volume rm $$volumes || true; \
		else \
			echo "$(YELLOW)Aucun volume à supprimer.$(NC)"; \
		fi; \
		sudo rm -rf $(WORDPRESS_VOLUME)/*; \
		sudo rm -rf $(MARIADB_VOLUME)/*; \
	else \
		echo "$(YELLOW)Suppression des volumes et des données persistantes annulée.$(NC)"; \
	fi

status:
	@echo "$(BLUE)État des conteneurs Docker et des images...$(NC)"
	@docker ps -a
	@docker images

help:
	@echo "$(YELLOW)Utilisation : make [cible]$(NC)"
	@echo "$(BLUE)Cibles disponibles :$(NC)"
	@echo "  $(GREEN)all$(NC)       - Construire et démarrer tous les conteneurs en mode détaché"
	@echo "  $(GREEN)build$(NC)     - Construire toutes les images Docker"
	@echo "  $(GREEN)up$(NC)        - Démarrer tous les conteneurs en mode détaché"
	@echo "  $(GREEN)down$(NC)      - Arrêter et supprimer conteneurs, réseaux, etc."
	@echo "  $(GREEN)stop$(NC)      - Arrêter tous les conteneurs en cours d'exécution"
	@echo "  $(GREEN)re$(NC)        - Reconstruire et redémarrer tous les conteneurs"
	@echo "  $(GREEN)clean$(NC)     - Supprimer conteneurs, images pendantes, réseaux et nettoyer le système"
	@echo "  $(GREEN)fclean$(NC)    - Effectuer clean et supprimer tous les volumes et données persistantes"
	@echo "  $(GREEN)status$(NC)    - Vérifier l'état des conteneurs Docker et des images"
	@echo "  $(GREEN)help$(NC)      - Afficher ce message d'aide"

.DEFAULT_GOAL := help

%:
	@echo "$(RED)Cible inconnue : $@$(NC)"
	@$(MAKE) help

