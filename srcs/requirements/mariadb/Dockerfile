FROM debian:bookworm-slim

# Exposer le port par défaut de MariaDB
EXPOSE 3306

# Installer MariaDB et Vim
RUN apt-get update && apt-get install -y \
    mariadb-server \
    vim

# Créer le répertoire pour les données MariaDB
RUN mkdir -p /var/lib/mysql

# Assurer les bonnes permissions pour MariaDB
RUN chown -R mysql:mysql /var/lib/mysql && \
    chmod -R 755 /var/lib/mysql

# Copier le script d'installation
COPY tools/script.sh /script.sh

# Donner les permissions d'exécution au script
RUN chmod +x /script.sh

# Copier la configuration personnalisée de MariaDB
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Définir l'entrée du conteneur avec le script
ENTRYPOINT ["/script.sh"]
