# Créer les dossiers avec sudo si nécessaire
prepare:
	sudo mkdir -p /home/user/svanmarc/data/mariadb
	sudo mkdir -p /home/user/svanmarc/data/wordpress
	sudo chown -R $(USER):$(USER) /home/user/svanmarc/data/

# Commande pour démarrer le projet après avoir préparé les dossiers
up: prepare
	docker-compose -f ./srcs/docker-compose.yml up --build

# Commande pour arrêter le projet, puis le redémarrer
down-up:
	docker-compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans
	docker-compose -f ./srcs/docker-compose.yml up --build

# Nettoyer tous les volumes, conteneurs et réseaux
clean:
	docker-compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans
	docker system prune --all -f
	sudo rm -rf /home/user/svanmarc/data/mariadb /home/user/svanmarc/data/wordpress
