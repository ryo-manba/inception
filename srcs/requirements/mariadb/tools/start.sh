#!/bin/bash

# https://qiita.com/wakayama-y/items/a9b7380263da77e51711
if [ ! -e '.done' ]; then
    echo "[INFO] start mysql initialization."
    mysqld_safe &

    # mysqlが起動したかチェックする
    echo "[DEBUG] start ping"
    mysqladmin --wait --count 3 ping

    echo "[DEBUG] create database"
    mysql -e "CREATE DATABASE ${WP_DB_NAME};"
    mysql -e "CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    echo "[DEBUG] shutdown mysql"
    mysqladmin shutdown
    touch .done
else
    echo "[INFO] mysql initialization already done."
fi
echo "[DEBUG] initial setup is done."
mysqld_safe
