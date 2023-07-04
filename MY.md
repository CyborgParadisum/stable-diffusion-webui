```bash

./run_webui_mac.sh
```
```bash

git clone --recursive git@github.com:CyborgParadisum/stable-diffusion-webui.git
conda create -n sd-web-ui python=3.10
conda activate sd-web-ui

```
```bash
pip install --prefer-binary -r repositories/CodeFormer/requirements.txt 
pip install rich
# for CodeFormer
cd repositories/CodeFormer && python basicsr/setup.py develop
pip uninstall basicsr -y
pip install basicsr 
```

## for add new git submodule

```bash
git submodule add https://github.com/Mikubill/sd-webui-controlnet.git extensions/sd-webui-controlnet/ 
git submodule add https://github.com/fkunn1326/openpose-editor.git extensions/openpose-editor/

git submodule add https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git extensions/rembg/
git submodule add https://github.com/toriato/stable-diffusion-webui-wd14-tagger.git extensions/wd14-tagger/

git submodule add https://github.com/kohya-ss/sd-webui-additional-networks extensions/additional-networks
git submodule add https://github.com/hako-mikan/sd-webui-lora-block-weight extensions/lora-block-weight
git submodule add https://github.com/hako-mikan/sd-webui-supermerger extensions/supermerger
git submodule add https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris extensions/lycoris
git submodule add https://github.com/a2569875/stable-diffusion-webui-composable-lora extensions/composable-lora
```


## for my Linux
```bash
pip3 install torch==2.0.1 torchvision==0.15.2 --index-url https://download.pytorch.org/whl/cu118
```

https://kurokumasoft.com/2023/02/16/stable-diffusion-controlnet/
