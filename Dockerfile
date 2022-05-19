FROM alpine:3.15
MAINTAINER Emmett Culley <eculley@ccctechcenter.org>

RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    mkdir /run/nginx

RUN apk update

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

RUN apk --update --no-cache add \
  nginx \
  php8 \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-intl \
  php8-fileinfo \
  php8-fpm \
  php8-gd \
  php8-iconv \
  php8-json \
  php8-mbstring \
  php8-openssl \
  php8-pdo \
  php8-phar \
  php8-pdo_mysql \
  php8-pdo_pgsql \
  php8-pdo_sqlite \
  php8-pgsql \
  php8-session \
  php8-simplexml \
  php8-sqlite3 \
  php8-tokenizer \
  php8-xml \
  php8-xmlreader \
  php8-xmlwriter \
  php8-zip \
  php8-zlib \
  php8-pecl-redis \
  curl \
  py-pip

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

# Configure supervisor
RUN pip install --upgrade pip && \
    pip install supervisor && \
    pip install supervisor-stdout

RUN mkdir -p {/etc/nginx,/run/nginx,/var/run/php8-fpm,/var/log/supervisor}

RUN rm -f /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/php8/php-fpm.conf
ADD php-fpm.conf /etc/php8/php-fpm.conf

RUN rm -f /etc/php8/php.ini
ADD php.ini /etc/php8/php.ini

RUN ln -s /usr/bin/php8 /usr/bin/php

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

ADD supervisor_stdout.py /usr/lib/python3.9/site-packages/supervisor_stdout.py
ADD supervisord.conf /etc/supervisord.conf
ENV TIMEZONE America/Los_Angeles

# Add crontab file in the cron directory
ADD crontab /etc/crontabs/root

EXPOSE 80 9000

CMD ["supervisord"]
