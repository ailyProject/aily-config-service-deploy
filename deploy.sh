#!/bin/bash

set -e

# 更新系统
# 安装依赖
sudo apt-get update && sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev supervisor unzip -y

# 安装pyenv
# unzip -oq files/pyenv-master.zip -d $HOME
# mv $HOME/pyenv-master $HOME/.pyenv
# rm -rf $HOME/pyenv-master
# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
# echo 'eval "$(pyenv init --path)"' >> $HOME/.bashrc
# source $HOME/.bashrc

# # 安装python3.9.7
# mkdir -p $HOME/.pyenv/cache
# cp files/Python-3.9.19.tar.xz $HOME/.pyenv/cache
# $HOME/.pyenv/bin/pyenv install 3.9.19
# $HOME/.pyenv/bin/pyenv global 3.9.19

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

# 获取当前python版本
PYTHON_VERSION=$(python3 -V | awk '{print $2}')
echo "当前python版本: $PYTHON_VERSION"

python3 -m venv .venv
.venv/bin/pip install -r requirements.pip

# 修复pybleno的bug
cp files/BluetoothHCI.py .venv/lib/$PYTHON_VERSION/site-packages/pybleno/hci_socket/BluetoothHCI/

# 配置 supervisor
SUPERVISOR_CONF_DIR="/etc/supervisor/conf.d"
SUPERVISOR_CONF_FILE="supervisor/ailyconf.conf"

echo "[program: ailyconf]" > $SUPERVISOR_CONF_FILE
echo "command = $HOME/aily-config-service/.venv/bin/python main.py" >> $SUPERVISOR_CONF_FILE
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
