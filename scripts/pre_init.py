import sys
import os
import time
import shutil
from helper import xlog, execute_or_fatal
import defines

os.chdir(os.path.join(defines.scriptPath, '..'))

# xlog.info('xxx')


REINSTALL_FLAG = True
if len(sys.argv) >= 2:
    if sys.argv[1] == 'false':
        REINSTALL_FLAG = False

if REINSTALL_FLAG:
    if os.path.exists(defines.ROOT_DIR):
        shutil.rmtree(defines.ROOT_DIR)

if not defines.DISABLE_INFLUXDB and not os.path.exists(defines.INFLUXDB_DIR):
    xlog.info('new dir {}'.format(defines.INFLUXDB_DIR))
    os.makedirs(defines.INFLUXDB_DIR)
    with open(os.path.join(defines.INFLUXDB_DIR, 'new'), 'w') as file_writer:
        file_writer.write(time.asctime( time.localtime(time.time())))
    execute_or_fatal('docker run -d --name=influx_tmp ' + defines.INFLUXDB_IMAGE)
    execute_or_fatal('docker cp -a influx_tmp:/etc/influxdb/ ' + defines.INFLUXDB_DIR + '/etc')
    execute_or_fatal('docker rm -f influx_tmp')

if not defines.DISABLE_GRAFANA and not os.path.exists(defines.GRAFANA_DIR):
    xlog.info('new dir {}'.format(defines.GRAFANA_DIR))
    os.makedirs(defines.GRAFANA_DIR)
    with open(os.path.join(defines.GRAFANA_DIR, 'new'), 'w') as file_writer:
        file_writer.write(time.asctime( time.localtime(time.time())))
    execute_or_fatal('docker run -d --user root --name=grafana_tmp ' + defines.GRAFANA_IMAGE)
    execute_or_fatal('docker cp -a grafana_tmp:/etc/grafana/ ' + defines.GRAFANA_DIR + '/etc')
    execute_or_fatal('docker cp -a grafana_tmp:/var/lib/grafana/ ' + defines.GRAFANA_DIR + '/data')
    execute_or_fatal('docker cp -a grafana_tmp:/var/log/grafana/ ' + defines.GRAFANA_DIR + '/log')
    execute_or_fatal('docker rm -f grafana_tmp')

if not defines.DISABLE_REDIS and not os.path.exists(defines.REDIS_DIR):
    xlog.info('new dir {}'.format(defines.REDIS_DIR))
    os.makedirs(defines.REDIS_DIR)
    with open(os.path.join(defines.REDIS_DIR, 'new'), 'w') as file_writer:
        file_writer.write(time.asctime( time.localtime(time.time())))

if not defines.DISABLE_MYSQL and not os.path.exists(defines.MYSQL_DIR):
    xlog.info('new dir {}'.format(defines.MYSQL_DIR))
    os.makedirs(defines.MYSQL_DIR)
    with open(os.path.join(defines.MYSQL_DIR, 'new'), 'w') as file_writer:
        file_writer.write(time.asctime( time.localtime(time.time())))
    execute_or_fatal('docker run -d --name=mysql_tmp ' + defines.MYSQL_IMAGE)
    execute_or_fatal('docker cp -a mysql_tmp:/var/lib/mysql/ ' + defines.MYSQL_DIR + '/data')
    execute_or_fatal('docker cp -a mysql_tmp:/etc/mysql/conf.d/ ' + defines.MYSQL_DIR + '/config')
    execute_or_fatal('docker rm -f mysql_tmp')

if not defines.DISABLE_NGINX_PHP and not os.path.exists(defines.NGINX_DIR):
    xlog.info('new dir {}'.format(defines.NGINX_DIR))
    os.makedirs(defines.NGINX_DIR)
    with open(os.path.join(defines.NGINX_DIR, 'new'), 'w') as file_writer:
        file_writer.write(time.asctime( time.localtime(time.time())))
    os.makedirs(os.path.join(defines.NGINX_DIR, 'conf.d'))
    execute_or_fatal('docker run -d --name=nginx_tmp ' + defines.NGINX_IMAGE)
    execute_or_fatal('docker cp -a nginx_tmp:/usr/share/nginx/html/ ' + defines.NGINX_DIR + '/html')
    execute_or_fatal('docker cp -a nginx_tmp:/var/log/nginx/ ' + defines.NGINX_DIR + '/logs')
    execute_or_fatal('docker rm -f nginx_tmp')

if not defines.DISABLE_CASSANDRA and not os.path.exists(defines.CASSANDRA_DIR):
    xlog.info('new dir {}'.format(defines.CASSANDRA_DIR))
    os.makedirs(defines.CASSANDRA_DIR)
    with open(os.path.join(defines.CASSANDRA_DIR, 'new'), 'w') as file_writer:
        file_writer.write(time.asctime( time.localtime(time.time())))
    os.makedirs(os.path.join(defines.CASSANDRA_DIR, '0'))
    os.makedirs(os.path.join(defines.CASSANDRA_DIR, '1'))
