# alpine-nginx-phpfpm-pgsql

Alpine image with NGINX, PHP, and PostgreSQL.

## Getting Started

### Prerequisites

To run this container, you'll need Docker Desktop installed.

* [Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
* [OS X](https://docs.docker.com/desktop/setup/install/mac-install/)
* [Linux](https://docs.docker.com/desktop/setup/install/linux/)

### Usage

#### Volumes

* `/var/www` - Web server root directory
* `/etc/nginx/sites-enabled` - NGINX config directory

#### Useful File Locations

* `/etc/nginx` - NGINX directory
* `/run/nginx` - NGINX directory
* `/run/php82` - PHP 8.2 directory
* `/run/supervisor` - Supervisord directory
* `/var/log/supervisor` - Supervisord logs

## Built With

* Alpine 3.19
* CUrl
* NGINX
* Node.js
* NPM 10.5.0
* PHP 8.2
* Supervisord

## Find Us

* [GitHub](https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql)

## Versioning

For the versions available, see the
[tags on this repository](https://github.com/your/repository/tags).

## Authors

* **UT Fong** - *Maintenance: Created this doc, not the repo* - [ufongccctc](https://github.com/ufongccctc)

See also the list of [contributors](https://github.com/your/repository/contributors) who
participated in this project.

## License

This project is licensed under [CCC Technology Center](https://ccctechcenter.org/).
