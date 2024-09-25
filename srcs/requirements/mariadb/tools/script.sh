#!/bin/bash

service mariadb start

mysql -e "CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DB}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${WORDPRESS_USER}\`@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${WORDPRESS_DB}\`.* TO \`${WORDPRESS_USER}\`@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

service mariadb stop

# Démarrer MariaDB en premier plan pour que le container continue de tourner
exec mysqld
