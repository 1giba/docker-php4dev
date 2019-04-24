# Docker - PHP for Developers

A lightweight image for php applications based on [codecasts/php-alpine](https://github.com/codecasts/php-alpine).

## From Hub Docker

To view available images, [click here](https://hub.docker.com/r/php4all/docker-php4dev).

To pull lastest image, run:

```sh
docker pull php4all/docker-php4dev
```

To pull other image, add the required version of php:

```sh
docker pull php4all/docker-php4dev:7.2
```

### Avaliable PHP Versions

* php 7.3.3/Nginx 1.15.12/Alpine 3.9;
* php 7.2.15/Nginx 1.14.2/Alpine 3.8.

**Basic libs:**

```ini
[PHP Modules]
Core
curl
date
dom
fileinfo
filter
gettext
hash
json
libxml
mbstring
openssl
pcre
PDO
Phar
readline
Reflection
session
SimpleXML
SPL
standard
tokenizer
xdebug
xml
xmlwriter
zlib

[Zend Modules]
Xdebug
```

Both of them has:

* Composer 1.8.5
* Node 8.15.1
* Yarn 1.12.3
* Supervisor 3.3.4
* User docker
* Timezone UTC

## From Sources

### Installation

Clone or download zip and extract to some path.

### PHP 7.3 Image

To create a docker image with php 7.3, run:

```
docker build -t php4all/docker-php4dev .
```

### PHP 7.2 Image

To create a docker image with php 7.2, run:

```
docker build -t php4all/docker-php4dev:7.2 -f ./Dockerfile-php7.2 .
```

## Basic Image

Execute the command:

```sh
docker run -d -p 5000:80 --name app php4all/docker-php4dev
```

And access in your browser:

```
http://127.0.0.1:5000
```

To access bash with docker user:

```sh
docker exec -ti --user docker app bash
```

To access bash with root user:

```sh
docker exec -ti app bash
```

### Customization

* edit nginx.conf;
* change timezone;
* create new user;
* change virtual host;
* adding more php libs.

#### Change Timezone

By default, UTC is setted for timezone, but you can change:

```sh
FROM php4all/docker-php4dev

# Change the timezone
RUN docker-timezone-change America/Sao_Paulo
```

#### Create New User

By default, the user docker was create with id 1000 and the same values for the group.

```sh
FROM php4all/docker-php4dev

# Create a new user
RUN docker-user-create app app 1001 1001
```

#### Configure Nginx

Change the configs above for nginx:

```sh
FROM php4all/docker-php4dev

# Edit /etc/nginx/nginx.conf
RUN docker-nginx-change \
        --worker-processes=auto \
        --worker-connections=1024 \
        --keep-timeout=65 \
        --expose-version=off \
        --client-body-buffer-size=16k \
        --client-max-body-size=1m \
        --large-client-header-buffers='4 8k'
```

#### Change Virtual Host

By default, the host of app is `app.dev.local` and your document root is `/var/www`.
Create a docker file and add the line above with the server name and the document root:

Example for Laravel app:

```sh
FROM php4all/docker-php4dev

# Change the virtual host
RUN docker-vhost-change laravel-app.dev /var/www/public
```

#### Adding PHP libs

Access [codecasts/php-alpine](https://github.com/codecasts/php-alpine#available-packages) to check the avaliable php libraries.

For example:

```sh
FROM php4all/docker-php4dev

# Adding php libs
RUN apk add --no-cache --update \
    php-pdo_mysql@php \
    php-redis@php \
    php-imagick@php
```

I hope you enjoy it.