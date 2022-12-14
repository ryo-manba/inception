#!/bin/bash

if [ ! -e '.done' ]; then
    echo "[INFO] start mysql initialization."
    mysqld_safe &

    until mysqladmin ping --silent; do
        echo "[INFO] waiting for mysqld to be connectable..."
        sleep 2
    done

    queryfile=$(mktemp)
    cat << EOF > $queryfile
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
    CREATE DATABASE ${WP_DB_NAME};
    CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASS}';
    GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOF
    mysql < $queryfile
    echo "[INFO] database created."
    rm -rf $queryfile

    mysqladmin -p${MYSQL_ROOT_PASS} shutdown
    touch .done
    echo "[INFO] initial setup is done."
else
    echo "[INFO] mysql initialization already done."
fi

echo "[INFO] MariaDB started."
mysqld_safe
