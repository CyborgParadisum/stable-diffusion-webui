#!/bin/bash
set -e

/home/peng/miniconda3/bin/conda init bash
#apt update
#apt install make
# 在启动之前运行的命令
echo "Running pre-start command..."
#your-command-here
git config --global --add safe.directory /app

source /root/.bashrc
export PATH=/home/peng/miniconda3/bin:$PATH
#make runuvicorn
# 启动服务
exec "$@"
