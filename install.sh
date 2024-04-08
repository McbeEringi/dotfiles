#!/bin/bash

CPU=$(grep 'model name' /proc/cpuinfo|grep -Pio -m1 'intel|amd'|awk '{print tolower($0)}')
GPU=$(lspci|grep -Pio -m1 'intel|amd|nvidia'|awk '{print tolower($0)}')
BASE_PKGS='
 base base-devel linux-firmware ${CPU}-ucode
 efibootmgr sudo nano git
 bluez bluez-utils chezmoi
 htop btop smartmontools lsplug powertop smartmontools ufw
 noto-fonts noto-fonts-cjk noto-fonts-emoji otf-monaspace
 fcitx5-im fcitx5-mozc
 arch-install-scripts
 man-db
'
HYPRLAND_PKGS='
 hyprland mako pipewire pipewire-pulse xdg-desktop-portal-hyprland xfce-polkit qt5-wayland qt6-wayland
 waybar hyprpaper wofi cliphist grimblast wlsunset wl-mirror brightnessctl
 greetd-tuigreet-bin
 thunar gvfs thunar-volman thunar-media-tags-plugin tumbler ffmpegthumbnailer zip wev
 foot
 gnome-keyring
 hyprlock hypridle hyprpicker
 iwgtk pavucontrol nwg-look-bin gnome-themes-extra papirus-icon-theme bibata-cursor-theme-bin qt5ct qt6ct
'
PLASMA_PKGS='
 plasma-meta
 dolphin konsole spectacle ufw
'

case $yn in
	'intel' ) BASE_PKGS='${BASE_PKGS} intel-media-driver intel-gpu-tools' ;;
	'amd' ) BASE_PKGS='${BASE_PKGS} libva-mesa-driver' ;;
	'nvidia' ) ;;
esac

while true; do
	read -n1 -p "rotate display = [yN] " yn;echo
	case $yn in
		[Yy]* ) ROTATE=true; break;;
		[Nn]*|'' ) ROTATE=false; break;;
	esac
done

while true; do
	read -n1 -p "kernel = [Yn] ? linux-zen : linux " yn;echo
	case $yn in
		[Yy]*|'' ) ZEN=true; BASE_PKGS='${BASE_PKGS} linux-zen'; break;;
		[Nn]* ) ZEN=false; BASE_PKGS='${BASE_PKGS} linux'; break;;
	esac
done

while true; do
	read -n1 -p "bootloader = [Yn] ? systemd-boot : grub " yn;echo
	case $yn in
		[Yy]*|'' ) SBOOT=true; break;;
		[Nn]* ) SBOOT=false; BASE_PKGS='${BASE_PKGS} grub os-prober'; break;;
	esac
done

while true; do
	read -n1 -p "desktop = [Yn] ? hyprland : plasma " yn;echo
	case $yn in
		[Yy]*|'' ) HYPRLAND=true; BASE_PKGS='${BASE_PKGS} iwd'; YAY_PKGS=$HYPRLAND_PKGS; break;;
		[Nn]* ) HYPRLAND=false; BASE_PKGS='${BASE_PKGS} networkmanager'; YAY_PKGS=$PLASMA_PKGS break;;
	esac
done

pacman -Sy archlinux-keyring
pacstrap -K /mnt $BASE_PKGS
genfstab -U /mnt >> /mnt/etc/fstab

cat <<EOF | arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# bootloader

git clone --depth=1 https://aur.archlinux.org/yay-bin /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si
cd ~
rm -rf /tmp/yay-bin

yay -S ${YAY_PKGS}
EOF
