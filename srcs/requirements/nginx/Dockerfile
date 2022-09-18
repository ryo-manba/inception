FROM debian:buster

# Debug
RUN set -ex

# Note:
#  vim, curlはデバッグ用なので、提出時に削除する
#  opensslはオレオレ証明書で使う
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Note:
#  sites-avalilableは、ドメインごとの設定ファイル置き場
#  sites-enbaleにシンボリックリンクを貼る
COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/inception.conf /etc/nginx/sites-available/
COPY ./tools/start.sh /usr/local/bin/

# entrypointの場合必ず実行される
ENTRYPOINT	[ "bash", "/usr/local/bin/start.sh" ]
