#!/bin/bash
set -e

if [ $# -eq 0 ]; then
    echo "No arguments supplied";
fi

function showHelp()
{
    echo -e "\e[1mOptions:\e[21m";
    echo "  --help";
    echo "  --worker-processes=auto [default=auto]";
    echo "  --worker-connections=1024 [default=1024]";
    echo "  --keep-timeout=65 [default=65]";
    echo "  --expose-version=off [default=off]";
    echo "  --client-body-buffer-size=16k [default=16k]";
    echo "  --client-max-body-size=1m [default=1m]";
    echo "  --large-client-header-buffers='4 8k' [default='4 8k']";
}

if [ "${1}" = "--help" ]; then
    showHelp;
else
    for arg in "$@"; do
        value=$(echo $arg | sed 's/^--.*=\([^ ]*\).*/\1/');
        case $arg in
            "--worker-processes="*)
                export NGINX_WORKER_PROCESSES=$value;;
            "--worker-connections="*)
                export NGINX_WORKER_CONNECTIONS=$value;;
            "--keep-timeout="*)
                export NGINX_KEEPALIVE_TIMEOUT=$value;;
            "--expose-version="*)
                export NGINX_EXPOSE_VERSION=$value;;
            "--client-body-buffer-size="*)
                export NGINX_CLIENT_BODY_BUFFER_SIZE=$value;;
            "--client-max-body-size="*)
                export NGINX_CLIENT_MAX_BODY_SIZE=$value;;
            "--large-client-header-buffers="*)
                export NGINX_LARGE_CLIENT_HEADER_BUFFERS=$value;;
        esac;
        printenv;
    done;

    envsubst < /templates/nginx.conf.tpl > /etc/nginx/nginx.conf
    echo -e "\e[32mFile '/etc/nginx/nginx.conf' updated\e[0m"
fi
