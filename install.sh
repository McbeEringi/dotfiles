#!/bin/bash

USE_ZEN_KERNEL=true
USE_SYSTEMD_BOOT=true
DESKTOP='hyprland' # 'plasma'
DISPLAY_ORIENTATION=0 # CHUWI MiniBook X N100 : 3
TIMEZONE='Asia/Tokyo'


CPU=$(grep 'model name' /proc/cpuinfo|grep -Pio -m1 'intel|amd'|awk '{print tolower($0)}')
GPU=$(lspci|grep -Pio -m1 'intel|amd|nvidia'|awk '{print tolower($0)}')

echo CPU: $CPU
echo GPU: $GPU

BASE_PKGS="
 base base-devel $($USE_ZEN_KERNEL && echo linux-zen || echo linux) linux-firmware $CPU-ucode
 $(
	[ $GPU == 'intel' ] && echo 'intel-media-driver intel-gpu-tools' ||
	[ $GPU == 'amd' ] && echo 'libva-mesa-driver' ||
	[ $GPU == 'nvidia' ] && echo 'nvidia-dkms' ||
	echo '[ERR] Unknown GPU'>&2
	)
 efibootmgr sudo nano git htop bluez bluez-utils
 noto-fonts noto-fonts-cjk noto-fonts-emoji otf-monaspace
 fcitx5-im fcitx5-mozc
 btop smartmontools lsplug powertop smartmontools ufw
 arch-install-scripts man-db chezmoi
"
HYPRLAND_PKGS="
 hyprland mako pipewire pipewire-pulse xdg-desktop-portal-hyprland xfce-polkit qt5-wayland qt6-wayland
 waybar hyprpaper wofi cliphist grimblast wlsunset wl-mirror brightnessctl
 hyprlock hypridle hyprpicker wev
 greetd greetd-tuigreet-bin
 thunar gvfs thunar-volman thunar-media-tags-plugin tumbler ffmpegthumbnailer zip
 foot
 gnome-keyring
 iwgtk pavucontrol nwg-look-bin qt5ct qt6ct
 gnome-themes-extra papirus-icon-theme bibata-cursor-theme-bin
"
PLASMA_PKGS="plasma-meta dolphin konsole spectacle"


echo $BASE_PKGS

read -p "Are you sure? [yes] " yn
if [[ $yn != 'yes' ]]; then exit; fi

echo ok
exit

pacman -Sy archlinux-keyring
pacstrap -K /mnt $BASE_PKGS
genfstab -U /mnt >> /mnt/etc/fstab

cat <<EOF | arch-chroot /mnt

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# bootloader

git clone --depth=1 https://aur.archlinux.org/yay-bin /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si
cd ~
rm -rf /tmp/yay-bin

yay -S ${YAY_PKGS}
EOF
