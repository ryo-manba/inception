#!/bin/bash

if [ ! -e '.done' ]; then
    echo "[INFO] start mysql initialization."
    mysql_install_db --user=mysql

    echo "[INFO] create database."
    mysqld -u mysql --bootstrap << EOF
    CREATE DATABASE ${WP_DB_NAME};
    CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
    GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOF

    touch .done
    echo "[INFO] initial setup is done."
else
    echo "[INFO] mysql initialization already done."
fi

echo "[INFO] MariaDB started."
mysqld_safe
