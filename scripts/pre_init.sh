#!/bin/bash
set -e

#
source scripts/defines.sh
source .env

REINSTALL_FLAG=true
if [ $# -eq 1 ];
then
  REINSTALL_FLAG=$1
fi

#
if $REINSTALL_FLAG; then
  if [[ -d ${ROOT_DIR} ]]; then
    rm -rf "${ROOT_DIR}"
  fi
fi

#
if $ENABLE_INFLUXDB && [[  ! -d ${INFLUXDB_DIR} ]]; then
  echo "new dir ${INFLUXDB_DIR}"
  mkdir -p "${INFLUXDB_DIR}"
  date +%Y-%m-%d_%H-%M-%S > "${INFLUXDB_DIR}/new"
  docker run -d --name=influx_tmp "${INFLUXDB_IMAGE}"
  docker cp -a influx_tmp:/etc/influxdb/ "${INFLUXDB_DIR}/etc"
  docker rm -f influx_tmp
fi

#
if $ENABLE_GRAFANA && [[  ! -d ${GRAFANA_DIR} ]]; then
  echo "new dir ${GRAFANA_DIR}"
  mkdir -p "${GRAFANA_DIR}"
  date +%Y-%m-%d_%H-%M-%S > "${GRAFANA_DIR}/new"
  docker run -d --user root --name=grafana_tmp "${GRAFANA_IMAGE}"
  docker cp -a grafana_tmp:/etc/grafana/ "${GRAFANA_DIR}/etc"
  docker cp -a grafana_tmp:/var/lib/grafana/ "${GRAFANA_DIR}/data"
  docker cp -a grafana_tmp:/var/log/grafana/ "${GRAFANA_DIR}/log"
  docker rm -f grafana_tmp
fi

#
if $ENABLE_REDIS && [[  ! -d ${REDIS_DIR} ]]; then
  echo "new dir ${REDIS_DIR}"
  mkdir -p "${REDIS_DIR}"
  date +%Y-%m-%d_%H-%M-%S > "${REDIS_DIR}/new"
fi

if $ENABLE_MYSQL && [[  ! -d ${MYSQL_DIR} ]]; then
  echo "new dir $MYSQL_DIR"
  mkdir -p "${MYSQL_DIR}"
  date +%Y-%m-%d_%H-%M-%S > "${MYSQL_DIR}/new"
  docker run -d --name=mysql_tmp "${MYSQL_IMAGE}"
  docker cp -a mysql_tmp:/var/lib/mysql/ "${MYSQL_DIR}/data"
  docker cp -a mysql_tmp:/etc/mysql/conf.d/ "${MYSQL_DIR}/config"
  docker rm -f mysql_tmp
fi

if $ENABLE_NGINX_PHP && [[  ! -d ${NGINX_DIR} ]]; then
  echo "new dir $NGINX_DIR"
  mkdir -p "${NGINX_DIR}"
  date +%Y-%m-%d_%H-%M-%S > "${NGINX_DIR}/new"
  docker run -d --name=nginx_tmp "${NGINX_IMAGE}"
  docker cp -a nginx_tmp:/usr/share/nginx/html/ "${NGINX_DIR}/html"
  mkdir -p "${NGINX_DIR}/conf.d"
  mkdir -p "${NGINX_DIR}/ssl"
  docker cp -a nginx_tmp:/etc/nginx/nginx.conf "${NGINX_DIR}/nginx.conf"
  docker cp -a nginx_tmp:/var/log/nginx/ "${NGINX_DIR}/logs"
  docker rm -f nginx_tmp
fi

if $ENABLE_CASSANDRA && [[  ! -d ${CASSANDRA_DIR} ]]; then
  echo "new dir ${CASSANDRA_DIR}"
  mkdir -p "${CASSANDRA_DIR}"
  mkdir -p "${CASSANDRA_DIR}/0"
  mkdir -p "${CASSANDRA_DIR}/1"
  date +%Y-%m-%d_%H-%M-%S > "${CASSANDRA_DIR}/new"
fi

if $ENABLE_JAEGER && [[  ! -d ${JAEGER_DIR} ]]; then
  echo "new dir ${JAEGER_DIR}"
  mkdir -p "${JAEGER_DIR}"
  mkdir -p "${JAEGER_DIR}/bader"
  date +%Y-%m-%d_%H-%M-%S > "${JAEGER_DIR}/new"
fi
