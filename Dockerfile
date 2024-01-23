FROM alpine:3.19
LABEL maintainer="Emmett Culley <eculley@ccctechcenter.org>"

RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    mkdir /run/nginx

RUN apk update

# Installing bash
#RUN apk add bash
#RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

RUN apk --update --no-cache add \
  nginx \
  php82 \
  php82-ctype \
  php82-curl \
  php82-dom \
  php82-intl \
  php82-fileinfo \
  php82-fpm \
  php82-gd \
  php82-iconv \
  php82-json \
  php82-mbstring \
  php82-openssl \
  php82-pdo \
  php82-phar \
  php82-pdo_mysql \
  php82-pdo_pgsql \
  php82-pdo_sqlite \
  php82-pgsql \
  php82-session \
  php82-simplexml \
  php82-sqlite3 \
  php82-tokenizer \
  php82-xml \
  php82-xmlreader \
  php82-xmlwriter \
  php82-zip \
  php82-zlib \
  php82-pecl-redis \
  curl \
  pipx\
  nodejs \
  npm \
  supervisor

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

# Configure supervisor
RUN pipx install supervisor-stdout
RUN npm install -g npm@latest

RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /run/php82
RUN mkdir -p /var/log/supervisor

RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/php82/php-fpm.d/www.conf
COPY php-fpm.conf /etc/php82/php-fpm.d/www.conf

#RUN rm -f /usr/bin/php
#RUN ln -s /usr/bin/php82 /usr/bin/php

RUN rm -f /etc/php82/php.ini
COPY php.ini /etc/php82/php.ini

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

# Uncomment the below to run the container stand alone
#RUN rm -f /etc/nginx/sites-enabled/default
#COPY sites /etc/nginx/sites-enabled/default

#RUN cat /usr/lib/python3.11/site-packages/supervisor_stdout.py

COPY supervisor_stdout.py /usr/lib/python3.11/site-packages/supervisor_stdout.py
COPY supervisord.conf /etc/supervisord.conf
ENV TIMEZONE America/Los_Angeles

# Add crontab file in the cron directory
COPY crontab /etc/crontabs/root

EXPOSE 80 9000

CMD ["supervisord"]
