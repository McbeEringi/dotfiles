#!/bin/bash
trap 'echo;echo exitting...;exit' INT
LANG=C
[ $PKGS ] || PKGS='
	plasma
	qt6-multimedia-ffmpeg pipewire-jack
	noto-fonts noto-fonts-emoji noto-fonts-cjk
	dolphin konsole
	fcitx5-im fcitx5-mozc 
'

which yay || {
	echo Installing yay...
	git clone --depth=1 https://aur.archlinux.org/yay-bin
	cd yay-bin
	makepkg -si --noconfirm
	cd -
	rm -rf yay-bin
}
yay -Syu --noconfirm --removemake $PKGS

sudo systemctl disable --now iwd systemd-resolved systemd-networkd
sudo rm /etc/resolv.conf
sudo systemctl enable --now NetworkManager sddm
