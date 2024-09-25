FROM debian:bookworm-slim

# Mise à jour et installation de NGINX et OpenSSL
RUN apt-get update && apt-get install -y nginx openssl

# Création du dossier SSL et génération du certificat auto-signé
RUN mkdir -p /etc/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -subj "/C=FR/ST=Occitanie/L=Perpignan/O=42/CN=svanmarc.42.fr"

# Créer le répertoire pour les fichiers NGINX
RUN mkdir -p /var/www/nginx && \
    chmod 755 /var/www/nginx && \
    chown -R www-data:www-data /var/www/nginx

# Copier le fichier de configuration de NGINX (par exemple, pour WordPress)
COPY conf/default /etc/nginx/sites-available/default

# Assurez-vous que le répertoire HTML existe et a les bonnes permissions
RUN mkdir -p /var/www/wordpress && \
    chmod 755 /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

# Commande pour démarrer NGINX en mode non-démon
CMD ["nginx", "-g", "daemon off;"]
