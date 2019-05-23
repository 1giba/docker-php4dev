#!/bin/bash
set -e

#
# If user not exists, create user and group based in envvars
#
if ! id "$DEV_USER" > /dev/null 2>&1; then
    addgroup -g $PGID $DEV_USER;
    adduser -u $PUID -D -G $DEV_GROUP $DEV_USER;
    cp /templates/.bashrc /home/${DEV_USER}/.bashrc;
    envsubst < /templates/php-fpm.d.tpl > /usr/local/etc/php-fpm.d/zz-docker.conf;
fi

#
# Change timezone
#
if ! grep "$TIMEZONE" /etc/timezone > /dev/null 2>&1; then
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime;
    echo $TIMEZONE > /etc/timezone;
    envsubst < /templates/php.custom.ini.tpl > /usr/local/etc/php/conf.d/custom.ini
fi

#
# Change vhost
#
if ! grep "$NGINX_SERVER_NAME" /etc/nginx/conf.d/default.conf > /dev/null 2>&1; then
    envsubst < /templates/nginx.host.tpl > /etc/nginx/conf.d/default.conf
fi

#
# Start nginx & php-fpm
#
/usr/bin/supervisord -c /etc/supervisord.conf