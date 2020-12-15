#!/bin/bash

source scripts/defines.sh
source .env

#
#
if $ENABLE_INFLUXDB; then
  docker exec -it influxdb influx -execute "CREATE USER admin WITH PASSWORD '$INFLUXDB_ADMIN_PASSWORD' WITH ALL PRIVILEGES"
  docker exec -it influxdb influx -execute "CREATE USER telegraf WITH PASSWORD 'metricsmetricsmetricsmetrics'"
  docker exec -it influxdb influx -execute "CREATE DATABASE telegraf"
  docker exec -it influxdb influx -execute "grant all on telegraf to telegraf"
  echo -e "\n[http]\n  auth-enabled = true\n" >> "${INFLUXDB_DIR}/etc/influxdb.conf"
  docker restart influxdb
fi

if $ENABLE_GRAFANA; then
  docker exec -it grafana /bin/bash -c 'grafana-cli plugins install grafana-piechart-panel' #安装饼状图插件
  docker exec -it grafana /bin/bash -c 'grafana-cli plugins install alexanderzobnin-zabbix-app' #安装zabbix插件(需要到仪表盘插件界面开启不然选择数据源时无法找到zabbix应用插件)
  docker exec -it grafana /bin/bash -c "grafana-cli plugins install grafana-clock-panel" #安装时间插件
  docker exec -it grafana /bin/bash -c "grafana-cli plugins install snuids-radar-panel" #安装雷达图插件
  docker exec -it grafana /bin/bash -c "grafana-cli plugins install redis-datasource" # redis
  docker restart grafana
fi
