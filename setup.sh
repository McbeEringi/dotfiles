#!/usr/bin/bash

bash <(curl -s https://dot.6ca.me/yay.sh)
bash <(curl -s https://dot.6ca.me/zsh.sh)

yay -S --noconfirm \
helix yazi chezmoi btop \
ly bcon polkit fbgrab keyd \
ffmpeg imagemagick 7zip resvg \
jq fd ripgrep fzf \
fcitx5 fcitx5-skk skk-emoji-jisyo \
pipewire-jack wireplumber \
otf-monaspace noto-fonts noto-fonts-emoji noto-fonts-cjk \
fastfetch

# npm
# hyprland xdg-desktop-portal-hyprland xfce-polkit foot fuzzel waybar pavucontrol firefox fcitx5-gtk fcitx5-qt qt5-wayland qt6-wayland \
# thunar gvfs
# git-delta

# lsplug platformio-core platformio-core-udev python-pip

chezmoi status||chezmoi init mcbeeringi --branch dev -a

sudo cp -r root/* /
sudo sed -iE "/BAT1/$(grep -l Battery /sys/class/power_supply/*/type | head -n1 | xargs dirname | xargs basename)/" /etc/ly/config.ini


# bcon via ly failed to resume input when back from other tty ?
# sudo ln -sf /usr/share/xsessions/bcon.desktop /etc/ly/custom-sessions/
# sudo ln -sf /usr/bin/bcon /usr/local/bin/

# for tty1
sudo systemctl disable getty@tty1 # $(systemctl show "*@tty1*" --state=loaded -P Id)
sudo systemctl enable ly@tty1

# for tty2~6 (autovt)
sudo ln -s /usr/lib/systemd/system/bcon@.service /etc/systemd/system/autovt@tty2.service
sudo ln -s /usr/lib/systemd/system/bcon@.service /etc/systemd/system/autovt@tty3.service

sudo systemctl enable keyd
