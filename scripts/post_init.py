import os
from tempfile import NamedTemporaryFile
from helper import xlog, execute_or_fatal
import defines

os.chdir(os.path.join(defines.scriptPath, '..'))

if not defines.DISABLE_INFLUXDB and os.path.isfile(os.path.join(defines.INFLUXDB_DIR, 'new')):
    execute_or_fatal('docker exec -it influxdb influx -execute "' + 'CREATE USER admin WITH PASSWORD ' +
                     '\'$INFLUXDB_ADMIN_PASSWORD\' ' + ' WITH ALL PRIVILEGES"')
    execute_or_fatal('docker exec -it influxdb influx -execute "' + \
                     'CREATE USER telegraf WITH PASSWORD \'metricsmetricsmetricsmetrics\'"')
    execute_or_fatal('docker exec -it influxdb influx -execute "' + 'CREATE DATABASE telegraf"')
    execute_or_fatal('docker exec -it influxdb influx -execute "' + 'grant all on telegraf to telegraf"')
    with open(os.path.join(defines.INFLUXDB_DIR, 'etc/influxdb.conf'), 'a+') as f:
        f.write('\n[http]\n  auth-enabled = true\n')
    execute_or_fatal('docker restart influxdb')
    os.remove(os.path.join(defines.INFLUXDB_DIR, 'new'))

if not defines.DISABLE_GRAFANA and os.path.isfile(os.path.join(defines.GRAFANA_DIR, 'new')):
    execute_or_fatal('docker exec -it grafana /bin/bash -c "' + 'grafana-cli plugins install grafana-piechart-panel' + '"')
    execute_or_fatal('docker exec -it grafana /bin/bash -c "' + 'grafana-cli plugins install alexanderzobnin-zabbix-app'+ '"')
    execute_or_fatal('docker exec -it grafana /bin/bash -c "' + 'grafana-cli plugins install grafana-clock-panel'+ '"')
    execute_or_fatal('docker exec -it grafana /bin/bash -c "' + 'grafana-cli plugins install snuids-radar-panel' + '"')
    execute_or_fatal('docker exec -it grafana /bin/bash -c "' + 'grafana-cli plugins install redis-datasource' + '"')
    execute_or_fatal('docker restart grafana')
    os.remove(os.path.join(defines.GRAFANA_DIR, 'new'))

if not defines.DISABLE_REDIS and os.path.isfile(os.path.join(defines.REDIS_DIR, 'new')):
    os.remove(os.path.join(defines.REDIS_DIR, 'new'))

if not defines.DISABLE_MYSQL and os.path.isfile(os.path.join(defines.MYSQL_DIR, 'new')):
    f = NamedTemporaryFile(mode="w+")
    f.write("ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '"+os.environ['MYSQL_ROOT_PASSWORD'] + "';\n")
    f.write('FLUSH PRIVILEGES;')
    f.flush()
    execute_or_fatal('docker cp ' + f.name + ' mysql:/tmp/do.sql')
    execute_or_fatal('docker exec -it mysql /bin/bash -c "' + 'mysql -uroot -p${MYSQL_ROOT_PASSWORD}</tmp/do.sql' + '"')
    os.remove(os.path.join(defines.MYSQL_DIR, 'new'))
    f.close()

if not defines.DISABLE_NGINX_PHP and os.path.isfile(os.path.join(defines.NGINX_DIR, 'new')):
    with open(os.path.join(defines.NGINX_DIR, 'html', 'info.php'), 'w') as file_writer:
        file_writer.write('<?php phpinfo(); ?>')
    with open(os.path.join(defines.NGINX_DIR, 'conf.d', 'default.conf'), 'w') as file_writer:
        file_writer.write('''
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
        ''')
    execute_or_fatal('docker-compose restart nginx')
    os.remove(os.path.join(defines.NGINX_DIR, 'new'))

if not defines.DISABLE_CASSANDRA and os.path.isfile(os.path.join(defines.CASSANDRA_DIR, 'new')):
    os.remove(os.path.join(defines.CASSANDRA_DIR, 'new'))

if not defines.DISABLE_JAEGER and os.path.isfile(os.path.join(defines.JAEGER_DIR, 'new')):
    os.remove(os.path.join(defines.JAEGER_DIR, 'new'))

if not defines.DISABLE_REGISTRY and os.path.isfile(os.path.join(defines.REGISTRY_DIR, 'new')):
    os.remove(os.path.join(defines.REGISTRY_DIR, 'new'))