#!/usr/bin/env bash
# Activate conda environment
#current_env=$(conda info --envs | grep "*" | awk '{print $1}')
#is_not_env=0
#if [[ $current_env != "sd-web-ui" ]]; then
#  conda activate sd-web-ui
#  is_not_env=1
#fi
# Pull the latest changes from the repo
#git pull --rebase
# Run the web ui
work_dir=$(dirname "$0")
cd ${work_dir}

export HF_HOME=${work_dir}/huggingface_cache
mkdir -p huggingface_cache
#export HF_HOME=${work_dir}/huggingface_cache
run="
python webui.py \
  --listen --port 17860 --disable-safe-unpickle \
  --skip-version-check \
  --enable-insecure-extension-access \
  --disable-nan-check \
  $*
"

if [ "$USE_CONDA" != "false" ];then
  cmd="conda run -n sd-web-ui --no-capture-output $run"
else
  cmd=$run
fi

echo "Running: $cmd"
exec $cmd
# Deactivate conda environment
#if ((is_not_env == 1)); then
#  conda activate sd-web-ui
#fi

