FROM debian:buster

# Debug
RUN set -ex

# debug: vim
RUN apt-get update; \
    apt-get -y install \
    mariadb-client \
    php \
    php-curl \
    php-dom \
    php-fpm \
    php-imagick \
    php-mbstring \
    php-mysqlnd \
    php-xml \
    php-zip \
    vim \
    wget; \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/start.sh /usr/local/bin/
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

ENTRYPOINT [ "bash", "/usr/local/bin/start.sh"]
