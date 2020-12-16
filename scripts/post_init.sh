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
