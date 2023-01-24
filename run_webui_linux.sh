#!/usr/bin/env bash
# Activate conda environment
current_env=$(conda info --envs | grep "*" | awk '{print $1}')
is_not_env=0
if [[ $current_env != "wd-web-ui" ]]; then
  conda activate wd-web-ui
  is_not_env=1
fi
# Pull the latest changes from the repo
#git pull --rebase
# Run the web ui
work_dir=$(dirname "$0")
cd ${work_dir}

export HF_HOME=${work_dir}/huggingface_cache
mkdir -p huggingface_cache
export HF_HOME=${work_dir}/huggingface_cache
python webui.py --listen --port 6006 --gradio-debug --disable-safe-unpickle

# Deactivate conda environment
if ((is_not_env == 1)); then
  conda activate wd-web-ui
fi

work_dir="/root/stable-diffusion-webui/"
cd ${work_dir}
mkdir huggingface_cache
export HF_HOME=${work_dir}/huggingface_cache
python webui.py --listen --port 6006 --gradio-debug --disable-safe-unpickle
