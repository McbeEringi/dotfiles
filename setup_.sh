#!/usr/bin/bash

yay -S \
neovim \
hyprland foot fuzzel waybar \
wireplumber pavucontrol ly \
monaspace noto-fonts noto-fonts-emoji noto-fonts-cjk \
pipewire-jack firefox

# sudo systemctl disable $(systemctl show "*@tty1*" --state=loaded -P Id)
# sudo systemctl enable ly@tty1
