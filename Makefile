ifneq ($(conda),false)
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
	bash $(run_sh)

#init_conda:
#	conda env create -f environment.yml
#	conda env list
install:
	$(conda_run) pip install -r requirements.txt
	#$(conda_run) pip install -r repositories/so_vits_svc/requirements-infer.txt

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
	$(call wget_if_not_exist, \
			models/Stable-diffusion/wd-1-4-anime_e1.ckpt ,\
			https://huggingface.co/hakurei/waifu-diffusion-v1-4/resolve/main/wd-1-4-anime_e1.ckpt)

	$(call wget_if_not_exist, \
			models/Stable-diffusion/chilloutmix_NiPrunedFp32Fix.safetensors ,\
			https://huggingface.co/naonovn/chilloutmix_NiPrunedFp32Fix/resolve/main/chilloutmix_NiPrunedFp32Fix.safetensors)


git_update:
	git pull --recurse-submodules
	#git submodule update --recursive
