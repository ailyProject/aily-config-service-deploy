# aily-config-service-deploy

## 使用
1. 添加`deploy.sh`的执行权限: `chmod +x deploy.sh`
2. 替换pip源（可选）
3. 替换apt源（可选）
4. 运行: `./deploy.sh`


## 部分问题及解决办法
1. 在树莓派bullseye系统上运行时会出现: `Network is down`的报错
- 解决：设置supervisor服务延时启动
- `sudo nano /lib/systemd/system/supervisor.service`, 新增如下内容：
    ```
    ...
    [Service]
    ExecStartPre=/bin/sleep 5
    ...
    ```