# Notes:
# 20240515: No need to install pip and supervisor-stdout. Supervisor-stdout is a python app that has not been updated
# for 3 years. Supervisord can output to stdout with stdout_logfile in supervisord.conf.
FROM alpine:3.19

# Change the maintainer to your info if you update this version of the image.
LABEL maintainer="UT Fong <ufong@ccctechcenter.org>"

# Clean up
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

# Update APK
RUN apk update

# Installing bash (why?)
#RUN apk add bash
#RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Install APK packages
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
  nodejs \
  npm \
  supervisor

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

# Add NPM for Vite--specifying which version
RUN npm install -g npm@10.5.0

# Add directories for nginx, php-fpm, supervisor
RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /run/php82
RUN mkdir -p /run/supervisor
RUN mkdir -p /var/log/supervisor

# Add nginx.conf
RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Add php-fpm.d/www.conf
RUN rm -f /etc/php82/php-fpm.d/www.conf
COPY php-fpm.conf /etc/php82/php-fpm.d/www.conf

# (What is this?)
#RUN rm -f /usr/bin/php
#RUN ln -s /usr/bin/php82 /usr/bin/php

# Add php.ini (will be overwritten by individual app's build process)
RUN rm -f /etc/php82/php.ini
COPY php.ini /etc/php82/php.ini

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

# Uncomment the below to run the container stand alone (debug only)
# This will be overwritten by individual app's build process
#RUN rm -f /etc/nginx/sites-enabled/default
#COPY sites /etc/nginx/sites-enabled/default

# Add supervisord.conf
COPY supervisord.conf /etc/supervisord.conf
ENV TIMEZONE America/Los_Angeles

# Add crontab file in the cron directory
COPY crontab /etc/crontabs/root

EXPOSE 80 9000

# Run supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
