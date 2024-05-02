# 树莓派源更换为国内源

> 更换为清华源（https://mirrors.tuna.tsinghua.edu.cn/help/debian/）

1. 备份现有源
    ```shell
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    ```
2. 更换为清华源
    > 将 /etc/apt/sources.list 文件中 Debian 默认的源地址 http://deb.debian.org/ 替换为镜像地址 https://mirrors.tuna.tsinghua.edu.cn 即可

    ```shell                                                                      
    deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm main contrib non-free non-free-firmware
    deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware
    deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm-updates main contrib non-free non-free-firmware
    ```