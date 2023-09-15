#!/usr/bin/env bash
# Activate conda environment
env_name="web-ui"
#current_env=$(conda info --envs | grep "*" | awk '{print $1}')
#is_not_env=0
#if [[ $current_env != "$env_name" ]]; then
#  conda activate $env_name
#  is_not_env=1
#fi
# Pull the latest changes from the repo
#git pull --rebase
# Run the web ui
work_dir=$(dirname "$0")
cd $work_dir
export HF_HOME=${work_dir}/huggingface_cache
export PYTORCH_ENABLE_MPS_FALLBACK=1
conda run -n sd-web-ui --no-capture-output python webui.py \
  --precision full --no-half --opt-split-attention-v1 --disable-nan-check \
  --loglevel DEBUG \
  $@


# Deactivate conda environment
#if ((is_not_env == 1)); then
#  conda activate $env_name
#fi


