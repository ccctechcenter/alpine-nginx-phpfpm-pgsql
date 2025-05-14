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
  php84 \
  php84-ctype \
  php84-curl \
  php84-dom \
  php84-intl \
  php84-fileinfo \
  php84-fpm \
  php84-gd \
  php84-iconv \
  php84-json \
  php84-mbstring \
  php84-openssl \
  php84-pdo \
  php84-phar \
  php84-pdo_mysql \
  php84-pdo_pgsql \
  php84-pdo_sqlite \
  php84-pgsql \
  php84-session \
  php84-simplexml \
  php84-sqlite3 \
  php84-tokenizer \
  php84-xml \
  php84-xmlreader \
  php84-xmlwriter \
  php84-zip \
  php84-zlib \
  php84-pecl-redis \
  curl \
  nodejs \
  npm \
  supervisor

# Add directories for nginx, php-fpm, supervisor
RUN mkdir -p /etc/nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /run/php84
RUN mkdir -p /run/supervisor
RUN mkdir -p /var/log/supervisor

# Add nginx.conf
RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Add php-fpm.d/www.conf
RUN rm -f /etc/php84/php-fpm.conf
RUN rm -f /etc/php84/php-fpm.d/www.conf
COPY php-fpm.conf /etc/php84/php-fpm.conf
COPY www.conf /etc/php84/php-fpm.d/www.conf

# Link the php84 to the php command line statement
RUN rm -f /usr/bin/php
RUN ln -s /usr/bin/php84 /usr/bin/php

# Add php.ini (will be overwritten by individual app's build process)
RUN rm -f /etc/php84/php.ini
COPY php.ini /etc/php84/php.ini

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
