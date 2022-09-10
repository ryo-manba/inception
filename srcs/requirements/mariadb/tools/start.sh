#!/bin/bash

# TODO: .envにまとめる
DB_NAME="wordpress"
DB_USER="sample"
DB_PASSWORD="password"

# https://qiita.com/wakayama-y/items/a9b7380263da77e51711
if [ ! -e '.done' ]; then
    echo "[INFO] start mysql initialization."
    mysqld_safe &

    # mysqlが起動したかチェックする
    echo "[DEBUG] start ping"
    mysqladmin --wait --count 3 ping

    echo "[DEBUG] create database"
    mysql -e "CREATE DATABASE ${DB_NAME};"
    mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

    echo "[DEBUG] shutdown mysql"
    mysqladmin shutdown
    touch .done
else
    echo "[INFO] mysql initialization already done."
fi
echo "[DEBUG] initial setup is done."
mysqld_safe
