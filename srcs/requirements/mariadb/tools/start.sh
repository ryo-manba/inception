#!/bin/bash

if [ ! -e '.done' ]; then
    echo "[INFO] start mysql initialization."
    mysqld_safe &

    echo "[INFO] create database"
    mysql -e "CREATE DATABASE ${WP_DB_NAME};"
    mysql -e "CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    mysqladmin shutdown
    touch .done
    echo "[INFO] initial setup is done."
else
    echo "[INFO] mysql initialization already done."
fi
echo "[INFO] MariaDB started."
mysqld_safe
