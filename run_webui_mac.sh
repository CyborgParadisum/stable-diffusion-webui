#!/usr/bin/env bash
# Activate conda environment
conda activate web-ui
# Pull the latest changes from the repo
#git pull --rebase
# Run the web ui
work_dir=$(dirname "$0")
cd $work_dir
export HF_HOME=${work_dir}/huggingface_cache
python webui.py --precision full --no-half --opt-split-attention-v1 --disable-nan-check
# Deactivate conda environment
conda deactivate

