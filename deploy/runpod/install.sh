#!/bin/bash

apt update && apt install tmux make vim lsof net-tools -y && \
python -m pip install --upgrade pip setuptools && \
pip install nvitop

cd /workspace
if [ ! -d stable-diffusion-webui ]; then
  git clone https://github.com/CyborgParadisum/stable-diffusion-webui.git -b sucicada --recursive
fi
cd /workspace/stable-diffusion-webui

export USE_CONDA=false
USE_CONDA=false make install
