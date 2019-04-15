[global]
daemonize = no

[www]
user = ${DEV_USER}
group = ${DEV_GROUP}

clear_env = no

; Ensure worker stdout and stderr are sent to the main error log.
catch_workers_output = yes

listen = ${PHP_FPM_FAST_CGI}
listen.owner = ${DEV_USER}
listen.group = ${DEV_GROUP}
listen.mode = 0666

pm.status_path = /status