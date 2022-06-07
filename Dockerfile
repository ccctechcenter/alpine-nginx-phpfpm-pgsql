FROM alpine:3.16
MAINTAINER Emmett Culley <eculley@ccctechcenter.org>

RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    mkdir /run/nginx

RUN apk update

# Installing bash
#RUN apk add bash
#RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

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
  py-pip \
  supervisor

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

# Configure supervisor
RUN pip install supervisor-stdout

RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /run/php8
RUN mkdir -p /var/log/supervisor

RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/php8/php-fpm.d/www.conf
COPY php-fpm.conf /etc/php8/php-fpm.d/www.conf

RUN rm -f /etc/php8/php.ini
COPY php.ini /etc/php8/php.ini

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

RUN rm -f /etc/nginx/sites-enabled/default
COPY sites /etc/nginx/sites-enabled/default

COPY supervisor_stdout.py /usr/lib/python3.10/site-packages/supervisor_stdout.py
COPY supervisord.conf /etc/supervisord.conf
ENV TIMEZONE America/Los_Angeles

# Add crontab file in the cron directory
COPY crontab /etc/crontabs/root

EXPOSE 80 9000

CMD ["supervisord"]
