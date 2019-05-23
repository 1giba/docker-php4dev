# Docker - PHP for Developers

A lightweight image for php applications based on [PHP Docker Official Image](https://hub.docker.com/_/php).

See the official documentation for installing/configuring php dependencies.

## From Hub Docker

To view available images, [click here](https://hub.docker.com/r/php4all/php4dev).

To pull lastest image, run:

```sh
docker pull php4all/php4dev
```

To pull other image, add the required version of php:

```sh
docker pull php4all/php4dev:7.2
```

### Avaliable PHP Versions

* php 7.3.5;
* php 7.2.18.

**Techonologies:**

* Alpine 3.9
* Composer 1.8.5
* Node 12.3.0
* Yarn 1.16.0
* Supervisor 3.3.4

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

The environment variables below can be changed:

```sh
docker run -d \
        -e PGID=1000 \
        -e PUID=1000 \
        -e DEV_GROUP=docker \
        -e DEV_USER=docker \
        -e NGINX_SERVER_NAME=example-app.com \
        -e NGINX_DOCUMENT_ROOT=/var/www/html/public \
        -e TIMEZONE=America/Sao_Paulo \
    php4all/php4dev
```

I hope you enjoy it.

---

> [1giba](https://github.com/1giba)