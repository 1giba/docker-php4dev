# Docker - PHP for Developers

A lightweight image for php applications based on [PHP Docker Official Image](https://hub.docker.com/_/php).

See the official documentation for installing/configuring php dependencies.

## From Hub Docker

To view available images, [click here](https://hub.docker.com/r/php4all/php4dev).

To pull lastest image, run:

```sh
docker pull php4all/php4dev:7.3
```

To pull other image, add the required version of php:

```sh
docker pull php4all/php4dev:7.2
```

### Avaliable PHP Versions

* php 7.3.10;
* php 7.2.23.

**Techonologies:**

* Alpine 3.10
* Nginx 1.16.1
* XDebug 2.7.2
* Composer 1.8.6
* Node 12.10.0
* Yarn 1.17.3
* Supervisor 3.3.5

## From Sources

### Installation

Clone or download zip and extract to some path.

### PHP 7.3 Image

To create a docker image with php 7.3, run:

```sh
docker build -t php4all/php4dev -f ./php/7.3/Dockerfile .
```

### PHP 7.2 Image

To create a docker image with php 7.2, run:

```sh
docker build -t php4all/php4dev:7.2 -f ./php/7.2/Dockerfile .
```

## Test container

Execute the command:

```sh
docker run -d -p 8080:80 php4all/php4dev
```

And access in your browser:

* [http://127.0.0.1:8080](http://127.0.0.1:8080)

### Customization

The environment variables can be changed:

```sh
docker run -d \
        -e PGID=1000 \
        -e PUID=1000 \
        -e GROUP_NAME=docker \
        -e USER_NAME=docker \
        -e NGINX_SERVER_NAME=example-app.com \
        -e NGINX_DOCUMENT_ROOT=/var/www/html/public \
        -e TIMEZONE=America/Sao_Paulo \
        -v /path/to/project:/var/www/html \
    php4all/php4dev
```

I hope you enjoy it.

---

> [1giba](https://github.com/1giba/docker-php4dev)
