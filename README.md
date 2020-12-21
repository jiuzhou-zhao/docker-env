1. 新环境首先执行`pre-init`命令
    ```bash
    make pre-init
    ```
2. 新环境需要执行配置密码策略
    1. `profile_pri.sh.sample`重命名拷贝 - 例如这里为 `~/.profile_pri.sh`
        1. 修改`~/.profile_pri.sh`文件中的密码
        2. 加入系统或用户`profile` - 这里以`mac`系统当前用户为例
            ```bash
            echo -e "source ~/.profile_pri.sh" >> ~/.zshrc
            ```
        3. 刷新`profile` - 这里以`mac`系统当前用户为例
            ```bash
           source ~/.zshrc
            ```
3. 拉取并启动镜像
    ```bash
   docker-compose up -d 
   ```
4. 新环境首先执行`post-init`命令
    ```bash
    make post-init
    ```

---
---
只做第`2`步骤，然后可以使用`make update-all`了

---
> https://cassandra.apache.org/doc/latest/faq/index.html#what-ports
>