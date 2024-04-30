#!/bin/bash

set -e

sudo apt-get update && sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev supervisor -y

# 安装pyenv
curl https://pyenv.run | bash
# 安装python3.9.7
pyenv install 3.9.19
pyenv global 3.9.19

# 克隆代码库
cd $HOME
# 判断是否已经存在aily-config-service目录, 存在则跳过
if [ -d "aily-config-service" ]; then
    echo "aily-config-service目录已存在"
else
    git clone -b py https://github.com/ailyProject/aily-config-service.git
fi

cd aily-config-service
git pull

# 创建虚拟环境并安装依赖
python3 -m venv .venv
.venv/bin/pip install -r requirements.pip

# 配置 supervisor
SUPERVISOR_CONF_DIR="/etc/supervisor/conf.d"
SUPERVISOR_CONF_FILE="supervisor/ailyconf.conf"

echo "[program: ailyconf]" > $SUPERVISOR_CONF_FILE
echo "command = $HOME/aily-config-service/venv/bin/python main.py" >> $SUPERVISOR_CONF_FILE
echo "directory = $HOME/aily-config-service" >> $SUPERVISOR_CONF_FILE
echo "user = root" >> $SUPERVISOR_CONF_FILE
echo "autostart = true" >> $SUPERVISOR_CONF_FILE
echo "autorestart = true" >> $SUPERVISOR_CONF_FILE
echo "stdout_logfile = /tmp/ailyconf.log" >> $SUPERVISOR_CONF_FILE
echo "stdout_logfile_maxbytes = 1MB" >> $SUPERVISOR_CONF_FILE
echo "stderr_logfile = /tmp/ailyconf-error.log" >> $SUPERVISOR_CONF_FILE
echo "stderr_logfile_maxbytes = 1MB" >> $SUPERVISOR_CONF_FILE

sudo cp $SUPERVISOR_CONF_FILE $SUPERVISOR_CONF_DIR
sudo supervisorctl reload

# 检查命令是否成功执行
if [ $? -eq 0 ]; then
    echo "部署成功"
else
    echo "部署失败"
fi