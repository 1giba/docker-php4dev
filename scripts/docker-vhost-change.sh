#!/bin/bash
set -e

if [ "$#" -ne 1 -a  "$#" -ne 2 ]; then
    echo -e "\e[31mSyntax: docker-vhost-create <SERVER_NAME> <DOCUMENT_ROOT>\e[0m"
else
    export NGINX_SERVER_NAME="${1}"
    if [[ -n "${2}" ]]; then
        export NGINX_DOCUMENT_ROOT="${2}";
    fi

    envsubst < /templates/nginx.host.tpl > /etc/nginx/conf.d/default.conf

    echo -e "\e[32mFile '/etc/nginx/conf.d/default.conf' updated\e[0m"
fi