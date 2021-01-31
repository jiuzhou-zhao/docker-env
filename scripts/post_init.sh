#!/bin/bash

set -e

source scripts/defines.sh
source .env

#
#
if $ENABLE_INFLUXDB; then
  if [[ -f ${INFLUXDB_DIR}/new ]]; then
    docker exec -it influxdb influx -execute "CREATE USER admin WITH PASSWORD '$INFLUXDB_ADMIN_PASSWORD' WITH ALL PRIVILEGES"
    docker exec -it influxdb influx -execute "CREATE USER telegraf WITH PASSWORD 'metricsmetricsmetricsmetrics'"
    docker exec -it influxdb influx -execute "CREATE DATABASE telegraf"
    docker exec -it influxdb influx -execute "grant all on telegraf to telegraf"
    echo -e "\n[http]\n  auth-enabled = true\n" >> "${INFLUXDB_DIR}/etc/influxdb.conf"
    docker restart influxdb
    rm -rf "${INFLUXDB_DIR}/new"
  fi
fi

if $ENABLE_GRAFANA; then
  if [[ -f ${GRAFANA_DIR}/new ]]; then
    docker exec -it grafana /bin/bash -c 'grafana-cli plugins install grafana-piechart-panel' #安装饼状图插件
    docker exec -it grafana /bin/bash -c 'grafana-cli plugins install alexanderzobnin-zabbix-app' #安装zabbix插件(需要到仪表盘插件界面开启不然选择数据源时无法找到zabbix应用插件)
    docker exec -it grafana /bin/bash -c "grafana-cli plugins install grafana-clock-panel" #安装时间插件
    docker exec -it grafana /bin/bash -c "grafana-cli plugins install snuids-radar-panel" #安装雷达图插件
    docker exec -it grafana /bin/bash -c "grafana-cli plugins install redis-datasource" # redis
    docker restart grafana
    rm -rf "${GRAFANA_DIR}/new"
  fi
fi

if $ENABLE_REDIS; then
  if [[ -f ${REDIS_DIR}/new ]]; then
    rm -rf "${REDIS_DIR}/new"
  fi
fi

if $ENABLE_MYSQL; then
  if [[ -f ${MYSQL_DIR}/new ]]; then
    tempFile=$(mktemp -t temp.XXXXXX)
    echo "tempFile is ${tempFile}"
    echo -e "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';" >> "${tempFile}"
    echo -e "FLUSH PRIVILEGES;" >> "${tempFile}"
    docker cp "${tempFile}" mysql:/tmp/do.sql
    docker exec -it mysql /bin/bash -c 'mysql -uroot -p${MYSQL_ROOT_PASSWORD}</tmp/do.sql'
    cat ${tempFile}
    rm -rf "${MYSQL_DIR}/new"
  fi
fi

if $ENABLE_NGINX_PHP; then
  if [[ -f ${NGINX_DIR}/new ]]; then
    cat > "${NGINX_DIR}/html/info.php" << "EOF"
<?php phpinfo(); ?>
EOF

    cat > "${NGINX_DIR}/conf.d/default.conf" << "EOF"
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        root           html;
        fastcgi_pass   php:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /www/$fastcgi_script_name;
        include        fastcgi_params;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
EOF
    docker-compose restart nginx
  fi
fi

if $ENABLE_CASSANDRA; then
  if [[ -f ${CASSANDRA_DIR}/new ]]; then
    rm -rf "${CASSANDRA_DIR}/new"
  fi
fi

if $ENABLE_JAEGER; then
  if [[ -f ${JAEGER_DIR}/new ]]; then
    rm -rf "${JAEGER_DIR}/new"
  fi
fi

