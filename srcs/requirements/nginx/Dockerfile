FROM debian:buster

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/nginx/ssl \
    && openssl req \
               -x509 \
               -sha256 \
               -newkey rsa:2048 \
               -days 365 \
               -nodes \
               -out /etc/nginx/ssl/nginx.crt \
               -keyout /etc/nginx/ssl/nginx.key \
               -subj "/C=JP/ST=Tokyo/L=Minato/O=42Tokyo/OU=Student/CN=localhost"

# Note:
#  sites-avalilableは、ドメインごとの設定ファイル置き場
#  sites-enbaleにシンボリックリンクを貼る
COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/inception.conf /etc/nginx/sites-available/
COPY ./tools/start.sh /usr/local/bin/

RUN ln -s /etc/nginx/sites-available/inception.conf /etc/nginx/sites-enabled/inception.conf \
    && rm -rf /etc/nginx/sites-enabled/default

ENTRYPOINT	[ "bash", "/usr/local/bin/start.sh" ]
