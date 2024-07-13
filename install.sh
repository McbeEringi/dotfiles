#!/bin/bash
trap 'echo;echo exitting...;exit' INT
mount|grep /mnt || { echo /mnt not detected. exiting...; exit; }
[[ $(swapon --show) ]] || { read -p "No swap detected. Continue? [yes] " ans;[[ $ans != 'yes' ]] && exit; }
echo
[ $ROOT_PASS ] || ROOT_PASS='password';echo ROOT_PASS	$ROOT_PASS
[ $USER_NAME ] || USER_NAME='user';echo USER_NAME	$USER_NAME
[ $USER_PASS ] || USER_PASS=$ROOT_PASS;echo USER_PASS	$USER_PASS
[ $TIMEZONE ] || TIMEZONE='Asia/Tokyo';echo TIMEZONE	$TIMEZONE
[ $LOCALE_GEN ] || LOCALE_GEN='en_US.UTF-8|ja_JP.UTF-8';echo LOCALE_GEN	$LOCALE_GEN
[ $LOCALE_USE ] || LOCALE_USE='ja_JP.UTF-8';echo LOCALE_USE	$LOCALE_USE
[ $KEYMAP ] || KEYMAP='jp106';echo KEYMAP	$KEYMAP
[ $CPU_VENDOR ] || CPU_VENDOR=$(grep 'model name' /proc/cpuinfo|grep -Pio -m1 'intel|amd'|awk '{print tolower($0)}');echo CPU_VENDOR	$CPU_VENDOR
[ $GPU_VENDOR ] || GPU_VENDOR=$(lspci|grep -Pio -m1 'intel|amd'|awk '{print tolower($0)}');echo GPU_VENDOR	$GPU_VENDOR # nvidia
echo
read -p "Are you sure you want to continue? [yes] " ans;[[ $ans != 'yes' ]] && exit

PACMAN_CONF_MODIFY="sed -i -E 's/^#(Color|VerbosePkgLists|ParallelDownloads)/\1/g' /etc/pacman.conf"

timedatectl
eval $PACMAN_CONF_MODIFY
pacman -Sy --noconfirm brightnessctl;brightnessctl s 10%
pacstrap -K /mnt base linux-zen linux-zen-headers linux-firmware $(
	([ $CPU_VENDOR == 'intel' ] && echo 'intel-ucode ') ||
	([ $CPU_VENDOR == 'amd' ] && echo 'amd-ucode ')
)$(
	([ $GPU_VENDOR == 'intel' ] && echo 'intel-media-driver intel-gpu-tools ') ||
	([ $GPU_VENDOR == 'amd' ] && echo 'libva-mesa-driver ')
)efibootmgr edk2-shell sudo nano git man-db base-devel iwd bluez bluez-utils
cp /etc/systemd/network/* /mnt/etc/systemd/network
genfstab -U /mnt |tee /mnt/etc/fstab
ROOT_UUID=$(grep -oP 'UUID=\S+(?=\s+\/\s)' /mnt/etc/fstab)
SWAP_UUID=$(grep -oP 'UUID=\S+(?=.+?swap)' /mnt/etc/fstab)

MAKEPKG_CONF_MODIFY="sed -i -E -e's/^(COMPRESSZST=\(zstd -c -T0).*?( -\))/\1\2/' -e's/^#(MAKEFLAGS=.*)/\1/' /etc/makepkg.conf"
MKINITCPIO_CONF_MODIFY="sed -i -E 's/^(HOOKS=\(base)( udev.+?filesystems)( fsck\))/\1 plymouth\2$([[ $SWAP_UUID ]] && echo ' resume')\3/' /etc/mkinitcpio.conf"
LOCALE_GEN_MODIFY="sed -i -E 's/#($LOCALE_GEN)/\1/g' /etc/locale.gen"
SUDOERS_MODIFY="sed -i -E 's/# (Defaults env_keep \+= "HOME"|%wheel ALL=\(ALL:ALL\) ALL)/\1/g' /etc/sudoers"

BOOTCTL_LOADER_CONF="cat <<_EOF |tee /boot/loader/loader.conf
default arch-zen.conf
timeout 3
console-mode keep
editor no
_EOF
"
BOOTCTL_ENTRIES_ARCH_ZEN_CONF="cat <<_EOF |tee /boot/loader/entries/arch-zen.conf
title Arch Linux w/ ZEN Kernel
linux /vmlinuz-linux-zen
$([[ $CPU_VENDOR ]] && echo initrd /$CPU_VENDOR-ucode.img)
initrd /initramfs-linux-zen.img
options root=$ROOT_UUID rw
options quiet splash
$([[ $SWAP_UUID ]] || echo '# ')options resume=$SWAP_UUID
# options video=DSI-1:panel_orientation=right_side_up
_EOF
"

SYSTEMCTL_EN="systemctl enable systemd-networkd systemd-resolved iwd systemd-timesyncd bluetooth"

cat <<EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
$LOCALE_GEN_MODIFY
locale-gen
echo LANG=$LOCALE_USE|tee /etc/locale.conf # localectl set-locale $LOCALE_USE
echo KEYMAP=$KEYMAP|tee /etc/vconsole.conf # localectl set-keymap $KEYMAP
$PACMAN_CONF_MODIFY
$MAKEPKG_CONF_MODIFY
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
$MKINITCPIO_CONF_MODIFY
pacman -S --noconfirm plymouth

cp /usr/share/edk2-shell/x64/Shell_Full.efi /boot/shellx64.efi
bootctl install
$BOOTCTL_LOADER_CONF
$BOOTCTL_ENTRIES_ARCH_ZEN_CONF

echo $ROOT_PASS|passwd -s root
useradd -m -g wheel $USER_NAME
echo $USER_PASS|passwd -s $USER_NAME
$SUDOERS_MODIFY

$SYSTEMCTL_EN
EOF

read -p "Press Enter to reboot..." ans;reboot