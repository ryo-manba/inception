#!/bin/bash

# 設定ファイル
ln -s /etc/nginx/sites-available/inception.conf /etc/nginx/sites-enabled/inception.conf
# 元々存在するファイルは不要なので削除する
rm -rf /etc/nginx/sites-enabled/default

# SSLの設定
mkdir /etc/nginx/ssl; \
openssl req \
        -x509 \
        -sha256 \
        -newkey rsa:2048 \
        -days 365 \
        -nodes \
        -out /etc/nginx/ssl/nginx.crt \
        -keyout /etc/nginx/ssl/nginx.key \
        -subj "/C=JP/ST=Tokyo/L=Minato/O=42Tokyo/OU=Student/CN=localhost"

# foregroudで起動する
nginx -g "daemon off;"
