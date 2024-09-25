FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -p /etc/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -subj "/C=FR/ST=France/L=Perpignan/O=42/CN=svanmarc.42.fr"

RUN mkdir -p /var/www/nginx && \
    chmod 755 /var/www/nginx && \
    chown -R www-data:www-data /var/www/nginx

COPY conf/default /etc/nginx/sites-available/default

RUN mkdir -p /var/www/wordpress && \
    chmod 755 /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

CMD ["nginx", "-g", "daemon off;"]
