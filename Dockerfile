FROM alpine:3.18
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
  php81 \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-intl \
  php81-fileinfo \
  php81-fpm \
  php81-gd \
  php81-iconv \
  php81-json \
  php81-mbstring \
  php81-openssl \
  php81-pdo \
  php81-phar \
  php81-pdo_mysql \
  php81-pdo_pgsql \
  php81-pdo_sqlite \
  php81-pgsql \
  php81-session \
  php81-simplexml \
  php81-sqlite3 \
  php81-tokenizer \
  php81-xml \
  php81-xmlreader \
  php81-xmlwriter \
  php81-zip \
  php81-zlib \
  php81-pecl-redis \
  curl \
  py-pip \
  nodejs \
  npm\
  supervisor

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

# Configure supervisor
RUN pip install supervisor-stdout
RUN npm install -g npm@latest

RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /run/php81
RUN mkdir -p /var/log/supervisor

RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/php81/php-fpm.d/www.conf
COPY php-fpm.conf /etc/php81/php-fpm.d/www.conf

RUN rm -f /etc/php81/php.ini
COPY php.ini /etc/php81/php.ini

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
