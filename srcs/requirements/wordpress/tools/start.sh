#!/bin/bash

until mysql -h${WP_DB_HOST} -P${WP_DB_PORT} -u${WP_DB_USER} -p${WP_DB_PASS} --silent; do
    echo "[INFO] waiting for mysqld to be connectable..."
    sleep 2;
done

# Bash script for checking whether WordPress is installed or not
if ! wp core is-installed --allow-root 2>/dev/null ; then
    echo "[INFO] Download WordPress"
    wp core download --locale=ja --allow-root

    echo "[INFO] Generate a config file"
    wp config create --dbname=${WP_DB_NAME} \
                     --dbuser=${WP_DB_USER} \
                     --dbpass=${WP_DB_PASS} \
                     --dbhost=${WP_DB_HOST} \
                     --allow-root

    echo "[INFO] Install WordPress"
    wp core install --url=${DOMAIN_NAME} \
                    --title=${WP_TITLE} \
                    --admin_user=${WP_ADMIN} \
                    --admin_email=${WP_ADMIN_EMAIL} \
                    --admin_password=${WP_ADMIN_PASSWORD} \
                    --allow-root

    echo "[INFO] Create user"
    wp user create --allow-root \
                    ${WP_USER} \
                    ${WP_USER_EMAIL} \
                   --user_pass=${WP_USER_PASSWORD}
fi

# Create directory for sock-file
mkdir -p /var/run/php

echo "[INFO] Wordpress started (port -> 9000)"
/usr/sbin/php-fpm7.3 --nodaemonize
