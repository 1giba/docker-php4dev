#!/bin/bash
set -e

if [ $# -eq 0 ]; then
    echo -e "\e[31mNo arguments supplied\e[0m";
else
    if [ $# -ne 1 ]; then
        echo -e "\e[31mOnly one argument is permitted\e[0m";
    else
        if [ "${1}" = '--help' ]; then
             echo -e "Syntax: docker-timezone-change America/Sao_Paulo";
        else
            export TIMEZONE="${1}";

            #
            # Configure timezone
            #
            apk add tzdata;
            cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime;
            echo $TIMEZONE > /etc/timezone;
            apk del tzdata;

            envsubst < /templates/php.custom.ini.tpl > /etc/php7/conf.d/custom.ini;
            echo -e "\e[32mTimezone updated\e[0m";
        fi
    fi
fi
