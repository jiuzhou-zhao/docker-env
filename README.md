## 安装

1. 新环境需要执行配置密码策略
    1. `profile_pri.sh.sample`重命名拷贝 - 例如这里为 `~/.profile_pri.sh`
        1. 修改`~/.profile_pri.sh`文件中的密码
        2. 加入系统或用户`profile`
            * `Mac`
                ```bash
                echo -e "source ~/.profile_pri.sh" >> ~/.zshrc
                source ~/.zshrc
                ```
            * `CentOS`
                ```bash
                echo -e "source ~/.profile_pri.sh" >> ~/.bash_profile
                source ~/.bash_profile
                ```
             * 其他
                ```bash
                请遵医嘱
               ```
2. 初始化 - 没有重试机制，如果哪个服务初始化出错了，则删除掉相应的数据目录重新执行

    ```bash
    sudo make update-all
    ```

---
>
> https://cassandra.apache.org/doc/latest/faq/index.html#what-ports
>
>

## 宿主机安装客户端

### Mac

#### redis-cli
```
wget https://download.redis.io/releases/redis-6.2.4.tar.gz
tar zxcv redis-6.2.4.tar.gz
cd redis-6.2.4
sudo make install
```

#### influxdb
```
brew tap patdz/influx-cli
brew update && brew doctor
brew install influx-cli
```

## 其他

* 安装PHP扩展 `docker-php-ext-install xx` 重启容器