#!/bin/bash
set -e

#
source scripts/defines.sh
source .env

#
rm -rf "${ROOT_DIR}" && true

#
if $ENABLE_INFLUXDB; then
  mkdir -p "${INFLUXDB_DIR}"
  docker run -d --name=influx_tmp influxdb
  docker cp -a influx_tmp:/etc/influxdb/ "${INFLUXDB_DIR}/etc"
  docker rm -f influx_tmp
fi

#
if $ENABLE_GRAFANA; then
  mkdir -p "${GRAFANA_DATA_DIR}"
  docker run -d --name=grafana_tmp grafana/grafana
  docker cp -a grafana_tmp:/etc/grafana/ "${GRAFANA_DATA_DIR}/etc"
  docker cp -a grafana_tmp:/var/lib/grafana/ "${GRAFANA_DATA_DIR}/data"
  docker cp -a grafana_tmp:/var/log/grafana/ "${GRAFANA_DATA_DIR}/log"
  docker rm -f grafana_tmp
fi

#
if $ENABLE_REDIS; then
  mkdir -p "${REDIS_DIR}"
fi

