#!/bin/bash
trap 'echo;echo exitting...;exit' INT
LANG=C
[ $PKGS ] || PKGS='
	hyprland mako pipewire pipewire-pulse pipewire-jack xdg-desktop-portal-hyprland xfce-polkit qt5-wayland qt6-wayland
	waybar hyprpaper wofi cliphist grimblast wlsunset wl-mirror brightnessctl
	hyprlock hypridle hyprpicker wev evtest
	greetd greetd-tuigreet
	thunar gvfs thunar-volman thunar-media-tags-plugin tumbler ffmpegthumbnailer zip unzip 7zip git-delta ripgrep
	foot
	gnome-keyring
	iwgtk pavucontrol qt5ct qt6ct kvantum-qt5 kvantum wdisplays
	gnome-themes-extra papirus-icon-theme bibata-cursor-theme-bin
	noto-fonts noto-fonts-cjk noto-fonts-emoji otf-monaspace ttf-nerd-fonts-symbols-common otf-kikai-chokoku-jis
	fcitx5 fcitx5-gtk fcitx5-qt fcitx5-skk
	btop smartmontools lsplug powertop
	arch-install-scripts exfatprogs ntfs-3g cdrtools chezmoi npm
	sway swayidle swaylock-effects idlehack autotiling-rs
	firefox neovim gimp satty mpv mpv-mpris imv discord_arch_electron imagemagick
	cowsay nyancat figlet cmatrix neofetch pipes.sh sl
	zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
	cups
'
# river kanshi
# niri

which yay || {
	echo Installing yay...
	git clone --depth=1 https://aur.archlinux.org/yay-bin
	cd yay-bin
	makepkg -si --noconfirm
	cd -
	rm -rf yay-bin
}
yay -Syu --noconfirm --removemake $PKGS

chezmoi status && {
	sudo cp -rn $(chezmoi data|jq -r .chezmoi.workingTree)/root/* /
} || {
	chezmoi init mcbeeringi
	sudo cp -r $(chezmoi data|jq -r .chezmoi.workingTree)/root/* /
}
chezmoi apply
sudo systemctl enable greetd cups
[[ $(cat /etc/passwd|grep -oP "^$USER:.*:\K.*") != "/bin/zsh" ]]&&chsh -s /bin/zsh
[[ $(hyprpm list|grep Hyprspace) ]]||{
	yay -S --noconfirm cmake meson cpio
	hyprpm update
	hyprpm add https://github.com/KZDKM/Hyprspace
	hyprpm enable Hyprspace
}
hyprpm update
hyprpm reload -n
read -p "Press Enter to reboot..." ans;reboot
