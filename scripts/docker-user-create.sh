#!/bin/bash
set -e

if [ "$#" -ne 2 -a "$#" -ne 3 -a "$#" -ne 4 ]; then
    echo -e "\e[31mSyntax: docker-user-create <USER_NAME> <GROUP_NAME> [USER_ID] [GROUP_ID]\e[0m"
else
    export DEV_USER="${1}"
    export DEV_GROUP="${2}"

    if [[ -n "${3}" ]]; then
        export PUID="${3}";
    fi

    if [[ -n "${4}" ]]; then
        export PGID="${4}";
    fi

    #
    # Create group if not exists
    #
    if [[ -z $(grep ${DEV_GROUP} /etc/group) ]]; then
        addgroup -g ${PGID} ${DEV_GROUP};
        echo -e "\e[32mGroup '${DEV_GROUP}' created\e[0m";
    fi

    #
    # Create user if not exists and check permissions
    #
    if [[ -z $(grep ${DEV_USER} /etc/passwd) ]]; then
        adduser -D -u ${PUID} -G ${DEV_GROUP} ${DEV_USER} \
            && cp  /templates/.bashrc /home/${DEV_USER}/.bashrc \
            && chown -R ${DEV_USER}:${DEV_GROUP} /home/${DEV_USER} \
            && chown -R ${DEV_USER}:${DEV_GROUP} /var/www;

        echo -e "\e[32mUser '${DEV_USER}' created\e[0m";
    fi

    envsubst < /templates/php-fpm.d.tpl > /etc/php7/php-fpm.d/zz_docker.conf;
    echo -e "\e[32mFile '/etc/php7/php-fpm.d/zz_docker.conf' added\e[0m";
fi
