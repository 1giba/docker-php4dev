#
# Official PHP Image
#
FROM php:7.2-fpm-alpine3.9

#
# Author
#
LABEL maintainer="Gilberto Junior <olamundo@gmail.com>"

#
# Copy scripts
#
COPY ./scripts/docker-entrypoint.sh /docker-entrypoint.sh

#
# Copy templates
#
COPY ./templates /templates

#
# Default values
#
ARG NGINX_VERSION=1.16.0
ARG NGINX_NJS_VERSION=0.3.1
ARG NGINX_PKG_RELEASE=1
ARG NODE_VERSION=12.3.0
ARG YARN_VERSION=1.16.0

#
# Env vars
#
ENV PGID=1000 \
    PUID=1000 \
    DEV_GROUP=www-data \
    DEV_USER=www-data \
    NGINX_SERVER_NAME=localhost \
    NGINX_DOCUMENT_ROOT=/var/www/html \
    NGINX_WORKER_PROCESSES=auto \
    NGINX_WORKER_CONNECTIONS=1024 \
    NGINX_KEEPALIVE_TIMEOUT=65 \
    NGINX_EXPOSE_VERSION=off \
    NGINX_CLIENT_BODY_BUFFER_SIZE=16k \
    NGINX_CLIENT_MAX_BODY_SIZE=1m \
    NGINX_LARGE_CLIENT_HEADER_BUFFERS="4 8k" \
    PHP_FPM_FAST_CGI=127.0.0.1:9000 \
    NGINX_VERSION=${NGINX_VERSION} \
    NGINX_NJS_VERSION=${NGINX_NJS_VERSION} \
    NGINX_PKG_RELEASE=${NGINX_PKG_RELEASE} \
    NODE_VERSION=${NODE_VERSION} \
    YARN_VERSION=${YARN_VERSION} \
    TIMEZONE=UTC \
    ESCAPE="$" \
    COMPOSER_ALLOW_SUPERUSER=1

#
# Install Libs
#
RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        git \
        gettext \
        libjpeg-turbo \
        libxml2 \
        supervisor \
        tzdata \
#
# Configure TIMEZONE
#
    && cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
#
# Install composer
#
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer  \
    && composer global require hirak/prestissimo \
#
# Install Nginx
#
    && set -x \
    && KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" \
    && apk add --no-cache --virtual .cert-deps \
        openssl \
    && curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
         echo "key verification succeeded!"; \
         mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
       else \
         echo "key verification failed!"; \
         exit 1; \
       fi \
    && printf "%s%s%s\n" \
        "http://nginx.org/packages/alpine/v" \
        `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
        "/main" \
    | tee -a /etc/apk/repositories \
    && apk del .cert-deps \
    && NGINX_PACKAGES=" \
        nginx=${NGINX_VERSION}-r${NGINX_PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-r${NGINX_PKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-r${NGINX_PKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-r${NGINX_PKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}.${NGINX_NJS_VERSION}-r${NGINX_PKG_RELEASE} \
    " \
    && apk add --no-cache $NGINX_PACKAGES \
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
    && if [ -n "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi \
    && if [ -n "/etc/apk/keys/nginx_signing.rsa.pub" ]; then rm -f /etc/apk/keys/nginx_signing.rsa.pub; fi \
#
# Forward request and error logs to docker log collector
#
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
#
# Install Node
#
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    && for key in \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
        77984A986EBC2AA786BC0F66B01FBB92821C587A \
        8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
        4ED778F539E3634C779C87C6D7062848A1AB005C \
        A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
        B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
        gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
#
# Install Yarn
#
    && apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
    && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
    ; do \
        gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
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
# Create a php file and configure nginx
#
    && echo "<?php phpinfo();" > /var/www/html/index.php  \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && chown -R ${DEV_USER}:${DEV_GROUP} /var/www/html \
#
# Change config files
#
    && envsubst < /templates/nginx.conf.tpl > /etc/nginx/nginx.conf \
    && envsubst < /templates/nginx.host.tpl > /etc/nginx/conf.d/default.conf \
    && envsubst < /templates/php.custom.ini.tpl > /usr/local/etc/php/conf.d/custom.ini \
    && envsubst < /templates/nginx.conf.tpl > /etc/nginx/nginx.conf \
    && envsubst < /templates/nginx.host.tpl > /etc/nginx/conf.d/default.conf \
#
# Create
#
    && chmod +x /docker-entrypoint.sh \
#
# Clear
#
    && rm -rf /tmp/* /var/cache/apk/* /usr/share/man

#
# Copy configs
#
COPY ./config/home/.bashrc /templates/.bashrc
COPY ./config/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./config/supervisor/docker.ini /etc/supervisor.d/docker.ini

#
# Init
#
WORKDIR /var/www/html

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/docker-entrypoint.sh"]
