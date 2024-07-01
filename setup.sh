#!/bin/bash
trap 'echo;echo exitting...;exit' INT

[ $PKGS ] || PKGS='
	hyprland mako pipewire pipewire-pulse pipewire-jack xdg-desktop-portal-hyprland xfce-polkit qt5-wayland qt6-wayland
	waybar hyprpaper wofi cliphist grimblast wlsunset wl-mirror brightnessctl
	hyprlock hypridle hyprpicker wev evtest
	greetd greetd-tuigreet-bin
	thunar gvfs thunar-volman thunar-media-tags-plugin tumbler ffmpegthumbnailer zip unzip p7zip
	foot
	gnome-keyring
	iwgtk pavucontrol nwg-look-bin qt5ct qt6ct wdisplays
	gnome-themes-extra papirus-icon-theme bibata-cursor-theme-bin
	noto-fonts noto-fonts-cjk noto-fonts-emoji otf-monaspace
	fcitx5-im fcitx5-mozc 
	btop smartmontools lsplug powertop
	arch-install-scripts dosfstools exfatprogs ntfs-3g chezmoi npm
	swayfx swayidle swaylock-effects idlehack autotiling-rs
	firefox code gimp mpv discord_arch_electron
	cowsay nyancat figlet cmatrix neofetch pipes.sh sl
	zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
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

chezmoi status || {
	chezmoi init mcbeeringi
	chezmoi cd
	sudo cp -r usr etc /
	chezmoi apply
	sudo systemctl enable greetd
}

chsh -s /bin/zsh