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
2. install

    ```bash
    sudo make update-all
    ```

---
>
> https://cassandra.apache.org/doc/latest/faq/index.html#what-ports
>