set -e

#
#
#
if [[ -f local.cfg  ]]; then
  source local.cfg
fi

if [[ ${DISABLE_REDIS} ]] && $DISABLE_REDIS; then
  ENABLE_REDIS=false
else
  ENABLE_REDIS=true
fi

if [[ ${DISABLE_INFLUXDB} ]] && $DISABLE_INFLUXDB; then
  ENABLE_INFLUXDB=false
else
  ENABLE_INFLUXDB=true
fi

if [[ ${DISABLE_GRAFANA} ]] && $DISABLE_GRAFANA; then
  ENABLE_GRAFANA=false
else
  ENABLE_GRAFANA=true
fi

if [[ ${DISABLE_MYSQL} ]] && $DISABLE_MYSQL; then
  ENABLE_MYSQL=false
else
  ENABLE_MYSQL=true
fi

if [[ ${DISABLE_NGINX_PHP} ]] && $DISABLE_NGINX_PHP; then
  ENABLE_NGINX_PHP=false
else
  ENABLE_NGINX_PHP=true
fi

#
#
#
if $ENABLE_REDIS; then
  echo "ENABLE REDIS"
fi

if $ENABLE_GRAFANA; then
  echo "ENABLE GRAFANA"
fi

if $ENABLE_INFLUXDB; then
  echo "ENABLE INFLUXDB"
fi

if $ENABLE_MYSQL; then
  echo "ENABLE MYSQL"
fi

if $ENABLE_NGINX_PHP; then
  echo "ENABLE NGINX PHP"
fi
