# 树莓派pip源更换为国内源
> 更换为清华源

1. 更改`/etc/pip.conf`的源
    ```
    [global]
    #extra-index-url=https://www.piwheels.org/simple
    extra-index-url=https://pypi.tuna.tsinghua.edu.cn/simple
    ```

2. 创建并设置 `~/.pip/pip.conf`
    ```
    mkdir ~/.pip
    nano ~/.pip/pip.conf

    # 配置以下内容
    [global]
    index-url=https://pypi.tuna.tsinghua.edu.cn/simple
    ```
    