# alpine-nginx-phpfpm-pgsql

Alpine image with NGINX, PHP, and PostgreSQL.

## Getting Started

### Prerequisites

To run this container, you'll need Docker Desktop installed.

* [Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
* [OS X](https://docs.docker.com/desktop/setup/install/mac-install/)
* [Linux](https://docs.docker.com/desktop/setup/install/linux/)

### Usage

This image can be used in `docker-compose.yml`, or be pulled in and built with `Dockerfile`.

#### Volumes

* `/var/www` - Web server root directory
* `/etc/nginx/sites-enabled` - NGINX config directory

#### Useful File Locations

* `/etc/nginx` - NGINX directory
* `/run/nginx` - NGINX directory
* `/run/php82` - PHP 8.2 directory
* `/run/supervisor` - Supervisord directory
* `/var/log/supervisor` - Supervisord logs

## Build

### Build the Image

1. Clone this repo (assuming you have access).
   ```
   git clone https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql.git
   ```

2. Make necessary changes.

3. Build the image. This will take a few minutes. 
   ```    
   docker build --no-cache .
   ```
### Test the Image

1. Find the newly created image. Look for an entry with REPOSITORY <none> and TAG <none> with the newest created date, note the IMAGE ID.
   ```
   docker image list
   ```

2. Test the image by running it with the IMAGE ID. Replace IMAGE_ID below with IMAGE ID found in step 1. The command should return a hash, note the hash.
   ```
   docker container run -d IMAGE_ID
   ```

3. Once everything has started up, you should be able to access the container's terminal via Docker Desktop. Open a terminal and retrieve the PHP version from the container. This should be successful.
   ```
   > php -v
   ```

4. Once everything is tested successfully. Stop the container with the container HASH from step 2.
   ```
   docker container stop HASH
   ```

### Tag and Push

1. Git add, commit, and tag. For example, we are releasing version 1.0.19.
   ```
   git status
   git add -u
   git commit -m "SCM-3300 Add Instructions to Build"
   git tag -a 1.0.19 -m "release 1.0.19"
   git push origin release/1.0.19 && git push origin 1.0.19
   ```
   
2. Docker tag image with IMAGE_ID found earlier.
   ```
   docker tag IMAGE_ID registry.ccctechcenter.org/ccctechcenter/alpine-nginx-phpfpm-pgsql:1.0.19
   ```
   
3. Docker push to repository (assuming you have access).
   ```
   docker push registry.ccctechcenter.org/ccctechcenter/alpine-nginx-phpfpm-pgsql:1.0.19
   ```

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
[tags on this repository](https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql/tags).

## Authors

* **UT Fong** - *Maintenance: Created this doc, not the repo* - [ufongccctc](https://github.com/ufongccctc)

See also the list of [contributors](https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql/contributors) who
participated in this project.

## License

This project is licensed under [CCC Technology Center](https://ccctechcenter.org/).
