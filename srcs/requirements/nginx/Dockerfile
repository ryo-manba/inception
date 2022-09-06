FROM debian:buster

# Debug
RUN set -ex

# Note:
#  vimはデバッグ用なので、提出時に削除する
#  opensslはオレオレ証明書で使う
RUN apt-get update; \
    apt-get -y --no-install-recommends install \
    nginx \
    openssl \
    vim; \
    rm -rf /var/lib/apt/lists/*

# Note:
#  sites-avalilableは、ドメインごとの設定ファイル置き場
#  sites-enbaleにシンボリックリンクを貼る
COPY ./srcs/inception.conf /etc/nginx/sites-available/
RUN  ln -s /etc/nginx/sites-available/inception.conf /etc/nginx/sites-enabled/inception.conf

# SSLの設定
RUN	mkdir /etc/nginx/ssl; \
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
CMD ["nginx", "-g", "daemon off;"]
