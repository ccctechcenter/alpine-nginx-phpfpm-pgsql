# Notes:
# 20240515: No need to install pip and supervisor-stdout. Supervisor-stdout is a python app that has not been updated
# for 3 years. Supervisord can output to stdout with stdout_logfile in supervisord.conf.
# 20250505: Update to latest version of Alpine, 3.21
FROM alpine:3.21

# Change the maintainer to your info if you update this version of the image.
LABEL maintainer="Ken Van Mersbergen <kvanmersbergen@ccctechcenter.org>"

# Clean up
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

# Update APK
RUN apk update && \
    apk upgrade

# Install APK packages
RUN apk --update --no-cache add \
  nginx \
  gnu-libiconv \
  php83 \
  php83-ctype \
  php83-curl \
  php83-dom \
  php83-intl \
  php83-fileinfo \
  php83-fpm \
  php83-gd \
  php83-iconv \
  php83-json \
  php83-mbstring \
  php83-openssl \
  php83-pdo \
  php83-phar \
  php83-pdo_mysql \
  php83-pdo_pgsql \
  php83-pdo_sqlite \
  php83-pgsql \
  php83-session \
  php83-simplexml \
  php83-sqlite3 \
  php83-tokenizer \
  php83-xml \
  php83-xmlreader \
  php83-xmlwriter \
  php83-zip \
  php83-zlib \
  php83-pecl-redis \
  curl \
  nodejs \
  npm \
  supervisor

# Add directories for nginx, php-fpm, supervisor
RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /run/php83
RUN mkdir -p /run/supervisor
RUN mkdir -p /var/log/supervisor

# Add nginx.conf
RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Add php-fpm.d/www.conf
RUN rm -f /etc/php83/php-fpm.d/www.conf
COPY php-fpm.conf /etc/php83/php-fpm.d/www.conf

# (What is this?)
#RUN rm -f /usr/bin/php
#RUN ln -s /usr/bin/php83 /usr/bin/php

# Add php.ini (will be overwritten by individual app's build process)
RUN rm -f /etc/php83/php.ini
COPY php.ini /etc/php83/php.ini

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

# Uncomment the below to run the container stand alone (debug only)
# This will be overwritten by individual app's build process
#RUN rm -f /etc/nginx/sites-enabled/default
#COPY sites /etc/nginx/sites-enabled/default

# Add supervisord.conf
COPY supervisord.conf /etc/supervisord.conf
ENV TIMEZONE=America/Los_Angeles

# Add crontab file in the cron directory
COPY crontab /etc/crontabs/root

EXPOSE 80 9000

# Run supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
