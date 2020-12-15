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

if [[ ${DISABLE_INFLUXDB} ]] && DISABLE_INFLUXDB; then
  ENABLE_INFLUXDB=false
else
  ENABLE_INFLUXDB=true
fi

if [[ ${DISABLE_GRAFANA} ]] && DISABLE_GRAFANA; then
  ENABLE_GRAFANA=false
else
  ENABLE_GRAFANA=true
fi

#
#
#
if $ENABLE_REDIS; then
  echo "USE REDIS"
fi

if $ENABLE_GRAFANA; then
  echo "USE GRAFANA"
fi

if $ENABLE_INFLUXDB; then
  echo "USE INFLUXDB"
fi
