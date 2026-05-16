#!/usr/bin/bash

yay -S \
helix \
ly bcon \
fcitx5 fcitx5-gtk fcitx5-qt fcitx5-skk skk-emoji-jisyo \
pipewire-jack wireplumber \
otf-monaspace noto-fonts noto-fonts-emoji noto-fonts-cjk \
fastfetch

# keyd hyprland foot fuzzel waybar pavucontrol firefox\

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
_EOF

mkdir -p /etc/systemd/system/ly@.service.d
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
_EOF

# for tty1
sudo systemctl disable getty@tty1 # $(systemctl show "*@tty1*" --state=loaded -P Id)
sudo systemctl enable ly@tty1

# for tty2~6 (autovt)
sudo ln -s /usr/lib/systemd/system/bcon@.service /etc/systemd/system/autovt@tty2.service

# sudo systemctl enable keyd
