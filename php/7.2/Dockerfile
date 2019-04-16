#
# Composer
#
FROM composer:1.8 as composer

RUN composer global require hirak/prestissimo

#
# Author
#
MAINTAINER "Gilberto Junior" <olamundo@gmail.com>

#
# Nginx
#
FROM nginx:1.15-alpine

#
# Add key
#
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub


#
# Copy config files
#
COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/nginx/vhost.conf /etc/nginx/conf.d/default.conf
COPY ./config/php/default.ini /usr/local/etc/php/conf.d/default.ini
COPY ./config/php/custom.ini /usr/local/etc/php/conf.d/zzz_custom.ini
COPY ./config/php/xdebug.ini /usr/local/etc/php/conf.d/zzz_xdebug.ini
COPY ./config/php/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./config/supervisor/docker.ini /etc/supervisor.d/docker.ini

#
# Default values
#
ARG PGID=1000
ARG PUID=1000
ARG DEV_GROUP=docker
ARG DEV_USER=docker
ARG NGINX_SERVER_NAME=localhost
ARG NGINX_DOCUMENT_ROOT="/var/www/public"
ARG NGINX_WORKER_PROCESSES=1
ARG NGINX_WORKER_CONNECTIONS=1024
ARG NGINX_KEEPALIVE_TIMEOUT=65
ARG NGINX_EXPOSE_VERSION=off
ARG NGINX_CLIENT_BODY_BUFFER_SIZE=16k
ARG NGINX_CLIENT_MAX_BODY_SIZE=1m
ARG NGINX_LARGE_CLIENT_HEADER_BUFFERS="4 8k"
ARG PHP_DEPS='php-pdo_mysql@php'
ARG PHP_FPM_FAST_CGI=127.0.0.1:9000
ARG TIMEZONE='UTC'
ARG NODE_VERSION='8.15.1'
ARG YARN_VERSION='1.12.3'

#
# Env vars
#
ENV PGID=${PGID}
ENV PUID=${PUID}
ENV DEV_GROUP=${DEV_GROUP}
ENV DEV_USER=${DEV_USER}
ENV NGINX_SERVER_NAME=${NGINX_SERVER_NAME}
ENV NGINX_DOCUMENT_ROOT=${NGINX_DOCUMENT_ROOT}
ENV NGINX_WORKER_PROCESSES=${NGINX_WORKER_PROCESSES}
ENV NGINX_WORKER_CONNECTIONS=${NGINX_WORKER_CONNECTIONS}
ENV NGINX_KEEPALIVE_TIMEOUT=${NGINX_KEEPALIVE_TIMEOUT}
ENV NGINX_EXPOSE_VERSION=${NGINX_EXPOSE_VERSION}
ENV NGINX_CLIENT_BODY_BUFFER_SIZE=${NGINX_CLIENT_BODY_BUFFER_SIZE}
ENV NGINX_CLIENT_MAX_BODY_SIZE=${NGINX_CLIENT_MAX_BODY_SIZE}
ENV NGINX_LARGE_CLIENT_HEADER_BUFFERS=${NGINX_LARGE_CLIENT_HEADER_BUFFERS}
ENV PHP_DEPS=${PHP_DEPS}
ENV TIMEZONE=${TIMEZONE}
ENV NODE_VERSION=${NODE_VERSION}
ENV YARN_VERSION=${YARN_VERSION}
ENV ESCAPE='$'

#
# User
#
RUN set -x \
    && addgroup -g ${PGID} ${DEV_GROUP} \
    && adduser -D -u ${PUID} -G ${DEV_GROUP} ${DEV_USER} \
#
# Install Common
#
    && apk add --no-cache \
        bash \
        git \
        curl \
        gettext \
        tzdata \
        supervisor \
    && cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && apk del tzdata \
#
# Redirect output
#
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \

#
# Install PHP
#
    && echo "@php https://dl.bintray.com/php-alpine/v3.8/php-7.2" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
        php@php \
        php-curl@php \
        php-dom@php \
        php-fpm@php \
        php-gettext@php \
        php-json@php \
        php-mbstring@php \
        php-openssl@php \
        php-pdo@php \
        php-phar@php \
        php-session@php \
        php-xdebug@php \
        php-xml@php \
        php-zlib@php \
        $PHP_DEPS \
#
# Create symlinks
#
    && ln -sf /etc/php7 /etc/php \
    && ln -sf /usr/bin/php7 /usr/bin/php \
    && ln -sf /usr/sbin/php-fpm7 /usr/bin/php-fpm \
    && ln -sf /usr/lib/php7 /usr/lib/php \
#
# Install Node
#
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
    && for key in \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
        56730D5401028683275BD23C23EFEFE93C4CFFFE \
        77984A986EBC2AA786BC0F66B01FBB92821C587A \
        8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    ; do \
        gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
#
# Install Yarn
#
    && apk add --no-cache --virtual .build-deps-yarn gnupg tar \
    && for key in \
        6A010C5166006599AA17F08146C2130DFD2497F5 \
    ; do \
        gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
    && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && mkdir -p /opt \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && apk del .build-deps-yarn \
#
# Configure nginx & php
#
    && envsubst < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf \
    && envsubst < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf \
    && envsubst < /usr/local/etc/php-fpm.d/zz-docker.conf > /usr/local/etc/php-fpm.d/zz-docker.conf \
    && if [[ $PHP_DEPS != *"php-mysqlnd"* ]]; \
        rm /usr/lib/php7/modules/mysqlnd.so \
    fi \
    && if [[ $PHP_DEPS != *"php-pdo_mysql"* ]]; \
        rm /usr/lib/php7/modules/pdo_mysql.so \
    fi \
#
# Configure workspace
#
    && chown -R ${DEV_USER}:${DEV_GROUP} /home/${DEV_USER} \
    && mkdir -p /var/www \
    && chown -R ${DEV_USER}:${DEV_GROUP} /var/www \
#
# Clear
#
    && apk del libstdc++ \
    && rm -rf /tmp/* /var/cache/apk/* /usr/share/man

#
# Copy composer and prestissimo lib
#
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /tmp /home/docker/.composer

#
# Copy .bashrc
#
COPY ./config/home/.bashrc /home/${DEV_USER}/.bashrc

#
# Init
#
WORKDIR /var/www

STOPSIGNAL SIGTERM

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
