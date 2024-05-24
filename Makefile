#ifneq ($(conda),false)
ifneq ($(wildcard .env),)
	include .env
endif

ifeq ($(filter $(conda) $(USE_CONDA), false),)
	conda_env = sd-web-ui
	conda_run = conda run -n $(conda_env) --no-capture-output
endif

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	run_sh = run_webui_linux.sh
else ifeq ($(UNAME_S),Darwin)
	run_sh = run_webui_mac.sh
endif

run:
	if [ ! -f "config.json" ]; then cp my_config.json config.json ; fi
	bash $(run_sh) --api \
		--loglevel DEBUG \
		$(args)

#init_conda:
#	conda env create -f environment.yml
#	conda env list
install:
	$(conda_run) bash install_linux.sh

#download-model-moegoe:
#	mkdir -p models
#	cd models && \
#	gdown "1PuUC_4cOvWFwOuskOapCk4VLaUXIgLPZ" -O model.pth && \
#	gdown "1EGTJGwxIrjtyx6cJoF9-be5yw8YWV7OB" -O config.json

define wget_if_not_exist
	@if [ ! -f $(1) ]; then \
		mkdir -p $(dir $(1)); \
		wget -O $(1) $(2); \
	fi
endef
#so_vits_svc_dir = repositories/so_vits_svc/
#so_vits_svc_modules = $(so_vits_svc_dir)/_models
download:
	#$(call wget_if_not_exist, \
#			models/Stable-diffusion/mikapikazo-40000.ckpt ,\
#			https://huggingface.co/andite/mikapikazo-diffusion/resolve/main/mikapikazo-40000.ckpt)

	#$(call wget_if_not_exist, \
#			models/Stable-diffusion/wd-1-4-anime_e1.ckpt ,\
#			https://huggingface.co/hakurei/waifu-diffusion-v1-4/resolve/main/wd-1-4-anime_e1.ckpt)

	$(call wget_if_not_exist, \
			models/Stable-diffusion/chilloutmix_NiPrunedFp32Fix.safetensors ,\
			https://huggingface.co/naonovn/chilloutmix_NiPrunedFp32Fix/resolve/main/chilloutmix_NiPrunedFp32Fix.safetensors)
	$(call wget_if_not_exist, \
			models/Stable-diffusion/mix-pro-v4.safetensors ,\
			"https://civitai.com/api/download/models/34559?type=Model&format=SafeTensor&size=full&fp=fp16" )
#	$(call wget_if_not_exist, \
#			models/Stable-diffusion/novelaifinal-pruned.vae.pt ,\
#			https://SuCicada:$(hf_token)@huggingface.co/SuCicada/stable-diffusion-models/resolve/main/novelaifinal-pruned.vae.pt)
#	$(call wget_if_not_exist, \
#			models/Stable-diffusion/novelaifinal-pruned.ckpt ,\
#			https://SuCicada:$(hf_token)@huggingface.co/SuCicada/stable-diffusion-models/resolve/main/novelaifinal-pruned.ckpt)

	@# ======= VAE =======
	$(call wget_if_not_exist, \
			models/VAE/animevae.pt ,\
			https://huggingface.co/a1079602570/animefull-final-pruned/resolve/main/animevae.pt)

	@# ======= Lora =======
	$(call wget_if_not_exist, \
			models/Lora/koreanDollLikeness_v10.safetensors ,\
			https://huggingface.co/aimainia/koreanDollLikeness_v10/resolve/main/koreanDollLikeness_v10.safetensors)
	#$(call wget_if_not_exist, \
#			models/Lora/lain.safetensors ,\
#			https://civitai.com/api/download/models/34221)

backup_lora:
	#ls -l .env
	#realpath .env
	#cat ./.env | xargs -I {} export {}
	$(conda_run) bash -c "set -a; source .env;set +a; \
		python tools/lora_s3.py \
		backup --s3_bucket $(S3_BUCKET) --s3_prefix $(S3_PREFIX)"

git_update:
	git pull --recurse-submodules
	#git submodule update --recursive

