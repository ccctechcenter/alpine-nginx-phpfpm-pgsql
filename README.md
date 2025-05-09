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

* `/etc/nginx` - NGINX, configuration directory
* `/run/nginx` - NGINX directory, used for the pid and socket
* `/run/php83` - PHP 8.3 directory, used for the pid and socket
* `/run/supervisor` - Supervisord directory, used for the pid and socket
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
   docker build .
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

3. Once everything has started up, you should be able to access the container's terminal via Docker Desktop. Open a terminal, and get the PHP version. This should be successful.
   ```
   > php -v
   ```

4. Once everything is tested successfully. Stop the container with the container HASH from step 2.
   ```
   docker container stop HASH
   ```

### Tag and Push

0. #### Proper GitHub Configuration

   Make sure your local Git repo is configured for SSH access. In order to push to GitHub, your local git repo must be configured for SSH access, not HTTPS.
   Run the following command to determine how the your local repo is communicating with GitLab:
   ```
   git remote -v
   ```
   HTTPS access will give the following response:
   ```
   origin  https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql.git (fetch)
   origin  https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql.git (push)
   ```
   To configure SSH access to the repository run the following command:
   ```
   git remote set-url origin git@github.com:ccctechcenter/alpine-nginx-phpfpm-pgsql.git
   ```
   Verify the command was successful by running ```git remote -v``` and should the results for the SSH access.
   ```
   origin  git@github.com:ccctechcenter/alpine-nginx-phpfpm-pgsql.git (fetch)
   origin  git@github.com:ccctechcenter/alpine-nginx-phpfpm-pgsql.git (push)
   ```

   Now you will be able to push your branch up to GitHub.
 

1. Git add, commit, and tag. For example, we are releasing version 1.0.22.
   ```
   git status
   git add -u
   git commit -m "SCM-3324 & SCM-3236 Upgrade to Alpine 3.21 and PHP 8.3"
   git tag -a 1.0.22 -m "release 1.0.22"
   git push origin release/1.0.22 && git push origin 1.0.22
   ```
   
2. In the past, the image would be pushed to our docker registry. That has now changed and we push to Docker Hub.
   Also, we are building and pushing two images to support developers that are running Intel and Mac (note the new Mac's
   are running Apple silicon instead of Intel processors.) Therefore, to eliminate errors that originally showed themself
   in PHP, we are adding the following architectures, linux/amd64 and linux/arm64, to the Docker Hub repository.

   To build the images and push images for both architectures, run the following command:
   ```
   docker buildx build . --progress plain --push --platform linux/amd64,linux/arm64/v8 -t ccctechcenter/alpine-nginx-phpfpm-pgsql:1.0.22
   ```

   Below are the outdated instructions to tag and push the image, for posterity sake:
   ```
   docker tag IMAGE_ID registry.ccctechcenter.org/ccctechcenter/alpine-nginx-phpfpm-pgsql:1.0.21
   docker push registry.ccctechcenter.org/ccctechcenter/alpine-nginx-phpfpm-pgsql:1.0.21
   ```

## Built With

* Alpine 3.21
* Curl 8.12.1
* nginx 1.26.3 
* Node.js 22.13.1
* NPM 10.9.1
* PHP 8.3
* Supervisord

## Configuration Documentation

### Alpine
Although Alpine does not have any customization, it is worth noting that at the time of this build (2005-05-09), the 
base image of this build, Alpine 3.21, does not have any reported vulnerabilities in Docker Scout.

### nginx
The following settings have been removed from our default NGINX config:
```
pcre_jit on;
server_tokens off;
client_max_body_size 1m;
tcp_nopush on;
ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers on;
ssl_session_cache shared:SSL:2m;
ssl_session_timeout 1h;
ssl_session_tickets off;
gzip_vary on;
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}
```
The following settings have been changed from their default values:
```
worker_processes 5;
error_log /dev/stderr debug;
access_log  /dev/stdout  main;
keepalive_timeout 300;
add_header Strict-Transport-Security "max-age=31536000; preload; includeSubDomains";
include /etc/nginx/sites-enabled/*;
daemon off;
```

### PHP 8.3
(will be updated in the future)

### Supervisord
The configuration for Supervisord accomplishes the following:
1. base configuration for the daemon
2. enable RPC interface for to allow daemons to be started, stopped, and restarted via the command line
3. enable the daemonization of the following programs:
   1. nginx: the web server
   2. php-fpm83: the php handler for the nginx
   3. crond: the scheduler that runs the artisan scheduled jobs


### Other
The following add-ins require no customization:
1. Curl
2. Node
3. NPM

## Find Us

* [GitHub](https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql)

## Versioning

For the versions available, see the
[tags on this repository](https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql/tags).

## Authors

* **UT Fong** - *Maintenance: Created this doc, not the repo* - [ufongccctc](https://github.com/ufongccctc)
* **Ken Van Mersbergen** *Maintenance: Upgraded this image to Alpine 3.21 and PHP 8.3

See also the list of [contributors](https://github.com/ccctechcenter/alpine-nginx-phpfpm-pgsql/contributors) who
participated in this project.

## License

This project is licensed under [CCC Technology Center](https://ccctechcenter.org/).
