#!/bin/bash

PHP_VERSION=$(php -v | head -n 1 | grep -oP '(?<=PHP )\d+\.\d+')

sed -i -e "s/.*listen = .*/listen = 9000/" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

if [[ -z "$WORDPRESS_DB" || -z "$WORDPRESS_USER" || -z "$WORDPRESS_PASSWORD" || -z "$WORDPRESS_DB_HOST" || -z "$WP_EMAIL" ]]; then
    echo "Error: Missing essential environment variables."
    echo "WORDPRESS_DB, WORDPRESS_USER, WORDPRESS_PASSWORD, WORDPRESS_DB_HOST, and WP_EMAIL must be set."
    exit 1
fi

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Configuring wp-config.php..."
    wp config create --dbname=${WORDPRESS_DB} --dbuser=${WORDPRESS_USER} --dbpass=${WORDPRESS_PASSWORD} --dbhost=${WORDPRESS_DB_HOST} --allow-root

    echo "Installing WordPress..."
    wp core install --url=${SITE_URL} --title="${SITE_TITLE}" --admin_user=${WP_USER} --admin_password=${WP_PASSWORD} --admin_email=${WP_EMAIL} --allow-root

    echo "Creating an additional user..."
    wp user create ${WP_USER1} ${WP_EMAIL1} --role=editor --user_pass=${WP_PASSWORD1} --allow-root
else
    echo "WordPress already installed. Skipping setup."
fi

exec /usr/sbin/php-fpm${PHP_VERSION} -F
