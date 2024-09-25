FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget php php-fpm php-mysql mariadb-client \
    php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

RUN mkdir -p /run/php && \
    chmod 775 /run/php && \
    chown www-data:www-data /run/php

COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

EXPOSE 9000

ENTRYPOINT ["/script.sh"]
