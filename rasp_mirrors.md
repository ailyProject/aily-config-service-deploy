# 树莓派源更换为国内源

1. 备份现有源
    ```shell
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    ```
2. 更换为清华源
    > 参考清华源（https://mirrors.tuna.tsinghua.edu.cn/help/debian/）使用说明进行

    以下为bookworm的示例：
    ```shell                                                                      
    deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm main contrib non-free non-free-firmware
    deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware
    deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm-updates main contrib non-free non-free-firmware
    ```



## 其它问题

1. 换源后，更新提示GPG error缺少公钥
 ```
 sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <缺少的公钥>
 ```