#!/bin/bash

service mariadb start

if [[ -z "$WORDPRESS_DB" || -z "$WORDPRESS_USER" || -z "$WORDPRESS_PASSWORD" ]]; then
    echo "Error: Missing essential environment variables."
    echo "WORDPRESS_DB, WORDPRESS_USER, and WORDPRESS_PASSWORD must be set."
    exit 1
fi

mysql -e "CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DB}\`;"

mysql -e "CREATE USER IF NOT EXISTS \`${WORDPRESS_USER}\`@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${WORDPRESS_DB}\`.* TO \`${WORDPRESS_USER}\`@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

service mariadb stop

# Démarrer MariaDB en mode foreground pour garder le container actif
exec mysqld

