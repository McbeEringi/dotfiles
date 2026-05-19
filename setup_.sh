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
# hyprland foot fuzzel waybar pavucontrol firefox fcitx5-gtk fcitx5-qt qt5-wayland qt6-wayland \

chezmoi status||chezmoi init mcbeeringi --branch dev -a

cat <<_EOF | sudo tee /etc/keyd/default.conf
[ids]
*
[main]
katakanahiragana=layer(meta)
f23+leftshift+leftmeta=layer(control)
capslock=layer(control)
_EOF

cat <<_EOF | sudo tee /etc/ly/config.ini
edge_margin=1
sleep_cmd=/usr/bin/systemctl suspend

battery_id=$(grep -l Battery /sys/class/power_supply/*/type | head -n1 | xargs dirname | xargs basename)
clock=%F %T
show_tty=true

bigclock=en
border_fg=0x80000000
text_in_center=true
default_input=password
xinitrc=null
xsessions=null
clear_password=true

animation=dur_file
dur_file_path=/etc/ly/example.dur
dur_offset_alignment=bottomright
dur_x_offset=-1
dur_y_offset=-1

[cmd:F8]
name = screenshot
cmd = fbgrab /tmp/ly-\$(date -Iseconds).png
_EOF

sudo mkdir -p /etc/systemd/system/ly@.service.d
cat <<_EOF | sudo tee /etc/systemd/system/ly@.service.d/10-restart.conf
[Service]
Restart=always
StartLimitInterval=10s
StartLimitBurst=100
_EOF

cat <<_EOF | sudo tee /etc/bcon/config.toml
[terminal]
ime=true

[keyboard]
xkb_layout="jp"

[mouse]
natural_scroll=true
disable_while_typing=false
_EOF

sudo mkdir -p /etc/systemd/system/bcon@.service.d
cat <<_EOF | sudo tee /etc/systemd/system/bcon@.service.d/10-login.conf
# enable this to pass pam but fcitx5 will not work.
# [Service]
# PAMName=login
_EOF

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
