#!/usr/bin/bash

yay -S \
neovim \
hyprland foot fuzzel waybar \
wireplumber pavucontrol ly \
monaspace noto-fonts noto-fonts-emoji noto-fonts-cjk \
pipewire-jack firefox

# for tty1
sudo systemctl disable getty@tty1 # $(systemctl show "*@tty1*" --state=loaded -P Id)
sudo systemctl enable ly@tty1

# for tty2~6 (autovt)
sudo ln -s /usr/lib/systemd/system/ly@.service /etc/systemd/system/autovt@tty2.service
