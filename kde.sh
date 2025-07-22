#!/bin/bash
trap 'echo;echo exitting...;exit' INT
LANG=C
[ $PKGS ] || PKGS='
	plasma
	networkmanager
	qt6-multimedia-ffmpeg pipewire-jack
	noto-fonts noto-fonts-emoji noto-fonts-cjk
	dolphin konsole firefox neovim gimp mpv mpv-mpris imv discord_arch_electron imagemagick
	fcitx5-im fcitx5-mozc fcitx5-skk
	zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
	cups system-config-printer power-profiles-daemon
	jq npm
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

chezmoi status || chezmoi init mcbeeringi
chezmoi apply

[[ $(systemctl status systemd-networkd|grep 'Active: active') ]]&&{
	sudo systemctl disable --now iwd systemd-networkd
	sudo rm /etc/resolv.conf
}
[[ $(cat /etc/passwd|grep -oP "^$USER:.*:\K.*") != "/bin/zsh" ]]&&chsh -s /bin/zsh
sudo systemctl enable NetworkManager sddm cups power-profiles-daemon
read -p "Press Enter to reboot..." ans;reboot
