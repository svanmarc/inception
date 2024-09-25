#!/bin/bash

# Démarrer le service MariaDB
service mariadb start

# Vérifier que les variables d'environnement nécessaires sont définies
if [[ -z "$WORDPRESS_DB" || -z "$WORDPRESS_USER" || -z "$WORDPRESS_PASSWORD" ]]; then
    echo "Error: Missing essential environment variables."
    echo "WORDPRESS_DB, WORDPRESS_USER, and WORDPRESS_PASSWORD must be set."
    exit 1
fi

# Créer la base de données si elle n'existe pas déjà
mysql -e "CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DB}\`;"

# Créer l'utilisateur WordPress s'il n'existe pas et lui accorder les privilèges
mysql -e "CREATE USER IF NOT EXISTS \`${WORDPRESS_USER}\`@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${WORDPRESS_DB}\`.* TO \`${WORDPRESS_USER}\`@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Arrêter le service MariaDB pour le redémarrer en mode foreground
service mariadb stop

# Démarrer MariaDB en mode foreground pour garder le container actif
exec mysqld

