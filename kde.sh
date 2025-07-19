#!/bin/bash
trap 'echo;echo exitting...;exit' INT
LANG=C
[ $PKGS ] || PKGS='
	plasma
	networkmanager
	qt6-multimedia-ffmpeg pipewire-jack
	noto-fonts noto-fonts-emoji noto-fonts-cjk
	dolphin konsole firefox
	fcitx5-im fcitx5-mozc fcitx5-hazkey-bin
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

[[ $(systemctl status systemd-networkd|grep 'Active: active') ]]&&{
	sudo systemctl disable --now iwd systemd-networkd
	sudo rm /etc/resolv.conf
}
sudo systemctl enable --now NetworkManager sddm
