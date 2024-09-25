FROM debian:bookworm-slim

# Mettre à jour le système et installer les dépendances nécessaires
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget php php-fpm php-mysql mariadb-client \
    php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

# Télécharger et installer WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Définir le répertoire de travail pour WordPress
WORKDIR /var/www/wordpress

# Assurer les bonnes permissions pour le répertoire de WordPress
RUN chown -R www-data:www-data /var/www/wordpress

# Créer le répertoire pour le socket PHP et définir les permissions
RUN mkdir -p /run/php && \
    chmod 775 /run/php && \
    chown www-data:www-data /run/php

# Copier le script d'script pour gérer l'installation et le lancement de PHP-FPM
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

# Exposer le port 9000 pour PHP-FPM
EXPOSE 9000

# Définir l'script pour exécuter WordPress et PHP-FPM
ENTRYPOINT ["/script.sh"]
