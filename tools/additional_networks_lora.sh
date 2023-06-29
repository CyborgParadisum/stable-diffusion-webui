#!/bin/bash

additional_networks_lora="extensions/additional-networks/models/lora"
my_lora="../../../models/Lora"
if [[ -L "$additional_networks_lora" ]]; then
  echo "The directory is a symbolic link."
  link_target=$(readlink -f "$additional_networks_lora")

  if [[ "$link_target" == "$(readlink -f $my_lora)" ]]; then
    echo "The link points to the correct target."
  else
    echo "The link does not point to the correct target."
    mv "$additional_networks_lora" "$additional_networks_lora"_bak
    ln -s "$my_lora" "$additional_networks_lora"
  fi
else
  echo "The directory is not a symbolic link."
  mv "$additional_networks_lora" "$additional_networks_lora"_bak
  ln -s "$my_lora" "$additional_networks_lora"
fi

echo "Checking symbolic link"
ls -l "$additional_networks_lora"

echo "Checking target"
ls -ld "$(realpath "$additional_networks_lora")"
