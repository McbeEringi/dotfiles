#!/usr/bin/bash

yay -S \
neovim \
ly kmscon \
hyprland foot fuzzel waybar \
wireplumber pavucontrol \
monaspace noto-fonts noto-fonts-emoji noto-fonts-cjk \
pipewire-jack firefox

mkdir -p /etc/systemd/system/ly@.service.d
cat <<_EOF | sudo tee /etc/systemd/system/ly@.service.d/10-restart.conf
[Service]
Restart=always
StartLimitInterval=10s
StartLimitBurst=100
_EOF

cat <<_EOF | sudo tee /etc/kmscon/kmscon.conf
xkb-model=jp106
xkb-layout=jp
_EOF

# for tty1
sudo systemctl disable getty@tty1 # $(systemctl show "*@tty1*" --state=loaded -P Id)
sudo systemctl enable ly@tty1 # ly-kmsconvt@tty1

# for tty2~6 (autovt)
sudo ln -s /usr/lib/systemd/system/kmsconvt@.service /etc/systemd/system/autovt@tty2.service
