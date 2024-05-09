#!/bin/bash

set -e

# Assign the absolute path of pwd to DEPLOY_DIR
DEPLOY_TOOL_DIR=$(cd `dirname $0`; pwd)

# Update the system
# Install dependencies
sudo apt-get update && sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev supervisor -y

# Install pyenv
# unzip -oq files/pyenv-master.zip -d $HOME
# mv $HOME/pyenv-master $HOME/.pyenv
# rm -rf $HOME/pyenv-master
# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
# echo 'eval "$(pyenv init --path)"' >> $HOME/.bashrc
# source $HOME/.bashrc

# # Install Python 3.9.7
# mkdir -p $HOME/.pyenv/cache
# cp files/Python-3.9.19.tar.xz $HOME/.pyenv/cache
# $HOME/.pyenv/bin/pyenv install 3.9.19
# $HOME/.pyenv/bin/pyenv global 3.9.19

# Clone the code repository
cd $HOME
# Check if the "aily-config-service" directory already exists, skip if it does
if [ -d "aily-config-service" ]; then
    echo "Directory 'aily-config-service' already exists"
else
    git clone -b py https://github.com/ailyProject/aily-config-service.git
fi

cd aily-config-service
git config pull.rebase false
git pull

# Create a virtual environment and install dependencies
python3 -m venv .venv
.venv/bin/pip install -r requirements.pip

cp .env.example .env

if [ -d "../aily" ]; then
    echo "Directory 'aily' already exists"
else
    mkdir ../aily
    cp files/aily/.env_sample ../aily/.env
fi

# Get the current Python version
PYTHON_VERSION=$(python3 -V | awk '{print "python" substr($2, 1, length($2)-2)}')
echo "Current Python version: $PYTHON_VERSION"

# Fix the bug in pybleno
cp $DEPLOY_TOOL_DIR/files/BluetoothHCI.py .venv/lib/$PYTHON_VERSION/site-packages/pybleno/hci_socket/BluetoothHCI/

# Configure supervisor
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

# Check if the command executed successfully
if [ $? -eq 0 ]; then
    echo "Deployment successful"
else
    echo "Deployment failed"
fi
