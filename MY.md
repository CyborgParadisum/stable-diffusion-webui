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

```bash
git submodule add https://github.com/Mikubill/sd-webui-controlnet.git extensions/sd-webui-controlnet/ 
git submodule add https://github.com/fkunn1326/openpose-editor.git extensions/openpose-editor/
```


https://kurokumasoft.com/2023/02/16/stable-diffusion-controlnet/
