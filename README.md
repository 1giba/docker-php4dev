## dockerp

A lightweight images set of docker for php applications based on [codecasts/php-alpine](https://github.com/codecasts/php-alpine).

### Used Images

* nginx:1.15-alpine;
* composer:1.8;

### Installation

Clone or download zip and extract to some path.

### PHP 7.3 Image

Create a docker image with php 7.3:

```
docker build -t dockerp-7.3 -f ./php/7.3/Dockerfile .
```

### PHP 7.2 Image

Create a docker image with php 7.2:

```
docker build -t dockerp-7.2 -f ./php/7.2/Dockerfile .
```

### Docker network

Create a docker network:

```sh
docker network create --subnet=172.19.0.0/16 dev.local
```

### Containers

Default values for environment vars:

```sh
ENV PGID=1000
ENV PUID=1000
ENV DEV_GROUP=docker
ENV DEV_USER=docker
ENV NGINX_SERVER_NAME=localhost
ENV NGINX_DOCUMENT_ROOT="/var/www/public"
ENV NGINX_WORKER_PROCESSES=1
ENV NGINX_WORKER_CONNECTIONS=1024
ENV NGINX_KEEPALIVE_TIMEOUT=65
ENV NGINX_EXPOSE_VERSION=off
ENV NGINX_CLIENT_BODY_BUFFER_SIZE=16k
ENV NGINX_CLIENT_MAX_BODY_SIZE=1m
ENV NGINX_LARGE_CLIENT_HEADER_BUFFERS="4 8k"
ENV PHP_DEPS='php-pdo_mysql@php'
ENV PHP_FPM_FAST_CGI=127.0.0.1:9000
ENV TIMEZONE='UTC'
ENV NODE_VERSION='8.15.1'
ENV YARN_VERSION='1.12.3'
```

Create the container for Laravel App:

```sh
docker run -ti -d \
    --name my-app \
    --volume /path/to/app/root:/var/www \
    -e "NGINX_SERVER_NAME=my-app.dev.local" \
    -e "NGINX_DOCUMENT_ROOT=/var/www/public" \
    -e "PHP_DEPS=php-pdo_mysql@php php-ldap@php php-redis@php" \
    --net dev.local \
    --ip 172.19.0.x \
    --hostname my-app.dev.local \
    dockerp-7.x
```

Edit `/etc/hosts` file:

```sh
172.19.0.x my-app.dev.local
```

### Apps with PostgreSQL

Pull official postgres image:

```sh
docker pull postgres:10.7-alpine
```

Create a container to postgres with the same docker network `dev.local`:

```sh
docker run -d --name postgres-10.7 \
    --ip 172.19.0.1 \
    --hostname pgsql10-7.dev.local \
    --net dev.local \
    postgres:10.7-alpine
```

Pull pgadmin image:

```sh
docker pull dpage/pgadmin4
```

Create a container to pgadmin:

```sh
docker run -d --name pgadmin \
    --ip 172.19.0.2 \
    --hostname pgadmin.dev.local
    --net dev.local \
    dpage/pgadmin4
```

Create an app container:

```sh
docker run -d -name postgres-laravel-app \
    -e "NGINX_SERVER_NAME=postgres-laravel-app.dev.local" \
    -e "PHP_DEPS=php-pdo_pgsql@php php_redis@php' \
    -v /path/to/app/root:/var/www
    --ip 172.19.0.3 \
    --hostname postgres-laravel-app.dev.local \
    --net dev.local \
    dockerp-7.3
```

Edit `hosts` file:

```ini
172.19.0.1 postgres10-7.dev.local
172.19.0.2 pgadmin.dev.local
172.19.0.3 postgres-laravel-app.dev.local
```

To start containers, run:

```sh
docker start postgres-laravel-app postgres-10.7 pgadmin
```

To stop containers, run:

```sh
docker stop postgres-laravel-app postgres-10.7 pgadmin
```

Access bash from `postgres-laravel-app`:

```sh
docker exec -ti --user docker postgres-laravel-app bash
```

### Apps with MySQL

Pull official mysql image:

```sh
docker pull mysql:5.7
```

Create a container to postgres with the same docker network `dev.local`:

```sh
docker run -d --name mysql-5.7 \
    --ip 172.19.0.4 \
    --hostname mysql5-7.dev.local \
    --net dev.local \
    mysql:5.7
```

Pull pgadmin image:

```sh
docker pull phpmyadmin/phpmyadmin
```

Create a container to phpmyadmin:

```sh
docker run -d --name phpmyadmin \
    --ip 172.19.0.5 \
    --hostname phpmyadmin.dev.local
    --net dev.local \
    phpmyadmin/phpmyadmin
```

Create an app container:

```sh
docker run -d -name mysql-laravel-app \
    -e "NGINX_SERVER_NAME=mysql-laravel-app.dev.local" \
    -e "PHP_DEPS=php-pdo_mysql@php' \
    -v /path/to/app/root/path:/var/www
    --ip 172.19.0.6 \
    --hostname mysql-laravel-app.dev.local \
    --net dev.local \
    dockerp-7.2
```

Edit `hosts` file:

```ini
172.19.0.4 mysql5-7.dev.local
172.19.0.5 phpmyadmin.dev.local
172.19.0.6 mysql-laravel-app.dev.local
```

To start containers, run:

```sh
docker start mysql-laravel-app mysql-5.7 phpmyadmin
```

To stop containers, run:

```sh
docker stop mysql-laravel-app mysql-5.7 phpmyadmin
```

Access bash from `mysql-laravel-app`:

```sh
docker exec -ti --user docker mysql-laravel-app bash
```

### Create a custom image

To create a custom image, set the environment variables:

```sh
docker run -d \
    --name custom-app \
    --volume /path/to/app/root:/var/www \
     -e "PGID=1000"
     -e "PUID=1000"
     -e "DEV_GROUP=nginx"
     -e "DEV_USER=nginx"
     -e "NGINX_SERVER_NAME=custom-app.dev.local"
     -e "NGINX_DOCUMENT_ROOT=/var/www/public"
     -e "NGINX_WORKER_PROCESSES=1"
     -e "NGINX_WORKER_CONNECTIONS=1024"
     -e "NGINX_KEEPALIVE_TIMEOUT=65"
     -e "NGINX_EXPOSE_VERSION=off"
     -e "NGINX_CLIENT_BODY_BUFFER_SIZE=16k"
     -e "NGINX_CLIENT_MAX_BODY_SIZE=1m"
     -e "NGINX_LARGE_CLIENT_HEADER_BUFFERS='4 8k'"
     -e "PHP_DEPS='php-pdo_mysql@php'"
     -e "PHP_FPM_FAST_CGI=127.0.0.1:9000"
     -e "TIMEZONE='UTC'"
     -e "NODE_VERSION=8.15.1"
     -e "YARN_VERSION=1.12.3"
    -v /path/to/custom/app:/var/www
    --ip 172.19.0.x \
    --hostname custom-app.dev.local \
    --net dev.local \
    dockerp-7.x
```