import fileinput
import os
import logging

logging.basicConfig(level=logging.DEBUG)

scriptPath = os.path.split(os.path.realpath(__file__))[0]
logging.debug('script path is {}'.format(scriptPath))

cfgFile = os.path.join(scriptPath, "..", "local.cfg")

print (cfgFile)

DISABLE_REDIS = False
DISABLE_GRAFANA = False
DISABLE_INFLUXDB = False
DISABLE_MYSQL = False
DISABLE_NGINX_PHP = False
DISABLE_CASSANDRA = False


if os.path.isfile(cfgFile):
    for line in fileinput.input(cfgFile):
        if len(line) == 0 or line.startswith('#'):
            continue
        parts = line.split('=', 2)
        if len(parts) != 2:
            continue
        exec(parts[0] + ' = ' + parts[1].capitalize())

if not DISABLE_REDIS:
    logging.info('Enabled Redis')
if not DISABLE_GRAFANA:
    logging.info('Enabled Grafana')
if not DISABLE_INFLUXDB:
    logging.info('Enabled influxdb')
if not DISABLE_MYSQL:
    logging.info('Enabled mysql')
if not DISABLE_NGINX_PHP:
    logging.info('Enabled nginx and php')
if not DISABLE_CASSANDRA:
    logging.info('Enabled cassandra')


for line in fileinput.input(os.path.join(scriptPath, "..", ".env")):
    line = line.strip()
    if len(line) == 0 or line.startswith('#'):
        continue
    parts = line.split('=', 2)
    if len(parts) != 2:
        continue
    setter = parts[0] + ' = "' + parts[1] + '"'
    exec(setter)
