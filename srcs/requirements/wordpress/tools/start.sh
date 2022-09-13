#!/bin/bash

## TODO: .envにまとめる

# mysqlで作成した設定
DB_NAME="wordpress"
DB_USER="sample"
DB_PASS="password"

# wordpress
DOMAIN_NAME=rmatsuka.42.fr
TITLE=inception

WP_USER=rmatsuka
WP_USER_EMAIL=rmatuska@example.com
WP_USER_PASSWORD=password

WP_ADMIN=admin
WP_ADMIN_EMAIL=admin@example.com
WP_ADMIN_PASSWORD=password

DB_HOST=localhost
DB_PORT=3306

service mysql start

# Step 1 – Download WordPress
echo "[INFO] Download WordPress"
wp core download --locale=ja --allow-root

# mysqlの疎通確認
# https://gihyo.jp/dev/serial/01/mysql-road-construction-news/0012
# mysqladmin -hlocalhost -P3306 -uroot ping

# https://qiita.com/sakito/items/7ddcbfb49edc7a50c6d7
while ! mysql -h${DB_HOST} -P${DB_PORT} -u${DB_USER}  -p${DB_PASS} ${DB_NAME} --silent; do
	echo "[INFO] waiting for database"
	sleep 1;
done

	# Step 2 – Generate a config file
	echo "[INFO] Generate a config file"
	wp config create --dbname=${DB_NAME} \
	                 --dbuser=${DB_USER} \
	                 --dbpass=${DB_PASS} \
	                 --dbhost=localhost \
	                 --allow-root

	# Step 3 – Create the database
	# wp db create
	# skip

	# Step 4 – Install WordPress
	echo "[INFO] Install WordPress"
	wp core install --url=${DOMAIN_NAME} \
					--title=${TITLE} \
					--admin_user=${WP_ADMIN} \
					--admin_email=${WP_ADMIN_EMAIL} \
					--admin_password=${WP_ADMIN_PASSWORD} \
					--allow-root

	# Step 5 – Create user
	echo "[INFO] Create user"
	wp user create --allow-root \
					${WP_USER} \
					${WP_USER_EMAIL} \
				   --user_pass=${WP_USER_PASSWORD} \
		  		   --role=author


# https://stackoverflow.com/questions/29859131/unable-to-bind-listening-socket-for-address-php-fpm
# Create directory for sock-file:
mkdir -p /var/run/php

echo "[INFO] Wordpress started (port -> 9000)"
/usr/sbin/php-fpm7.3 --nodaemonize
