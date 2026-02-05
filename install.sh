#!/bin/bash
trap 'echo;echo exitting...;exit' INT
mount|grep /mnt >/dev/null || { echo /mnt not detected. exiting...; exit; }
[[ $(swapon --show) ]] || echo swap not found! # { read -p "No swap detected. Continue? [yes] " ans;[[ $ans != 'yes' ]] && exit; }
echo
[ $ROOT_PASS ] || ROOT_PASS='password';echo ROOT_PASS	$ROOT_PASS
[ $USER_NAME ] || USER_NAME='user';echo USER_NAME	$USER_NAME
[ $USER_PASS ] || USER_PASS=$ROOT_PASS;echo USER_PASS	$USER_PASS
[ $TIMEZONE ] || TIMEZONE='Asia/Tokyo';echo TIMEZONE	$TIMEZONE
[ $LOCALE_GEN ] || LOCALE_GEN='en_US.UTF-8|ja_JP.UTF-8';echo LOCALE_GEN	$LOCALE_GEN
[ $LOCALE_USE ] || LOCALE_USE='ja_JP.UTF-8';echo LOCALE_USE	$LOCALE_USE
[ $KEYMAP ] || KEYMAP='jp106';echo KEYMAP	$KEYMAP
[ $MIRROR_COUNTRY ] || MIRROR_COUNTRY='Japan';echo MIRROR_COUNTRY	$MIRROR_COUNTRY
[ $CPU_VENDOR ] || CPU_VENDOR=$(grep 'model name' /proc/cpuinfo|grep -Pio -m1 'intel|amd'|awk '{print tolower($0)}');echo CPU_VENDOR	$CPU_VENDOR
[ $GPU_VENDOR ] || GPU_VENDOR=$(lspci|grep -Pio -m1 'vga compatible.*\K(intel|amd)'|awk '{print tolower($0)}');echo GPU_VENDOR	$GPU_VENDOR # nvidia
[ $HOST_NAME ] && echo HOST_NAME	$HOST_NAME || echo HOST_NAME_UNSET
[ $WINDOWS_FSNUM ] && echo WINDOWS_FSNUM	$WINDOWS_FSNUM || echo WINDOWS_FSNUM_UNSET
echo
read -p "Are you sure you want to continue? [yes] " ans;[[ $ans != 'yes' ]] && exit

PACMAN_CONF_MODIFY="sed -i -E 's/^#(Color|VerbosePkgLists|ParallelDownloads)/\1/g' /etc/pacman.conf"

timedatectl
eval $PACMAN_CONF_MODIFY
systemctl stop reflector.service;echo "==> Rating mirrors...";reflector --save /etc/pacman.d/mirrorlist -p https -c "$MIRROR_COUNTRY" -l 5 --sort rate
pacman -Sy --noconfirm archlinux-keyring
pacman -S --noconfirm brightnessctl;brightnessctl s 10%
pacstrap -K /mnt base linux-zen linux-zen-headers linux-firmware dosfstools btrfs-progs $(
	([ "$CPU_VENDOR" == 'intel' ] && echo 'intel-ucode ') ||
	([ "$CPU_VENDOR" == 'amd' ] && echo 'amd-ucode ')
)$(
	([ "$GPU_VENDOR" == 'intel' ] && echo 'intel-media-driver intel-gpu-tools vulkan-intel ') ||
	([ "$GPU_VENDOR" == 'amd' ] && echo 'mesa vulkan-radeon ')
)efibootmgr edk2-shell sudo nano git openssh man-db base-devel iwd bluez bluez-utils sof-firmware keyd kexec-tools
cp /etc/systemd/network/* /mnt/etc/systemd/network
mkdir /mnt/var/lib/iwd;cp -r /var/lib/iwd/* /mnt/var/lib/iwd
bootctl install --esp-path=/mnt/boot
genfstab -U /mnt |tee /mnt/etc/fstab
BOOT_UUID=$(grep -oP 'UUID=\K\S+(?=\s+\/boot\s)' /mnt/etc/fstab)
BOOT_PKNAME=$(lsblk -nro UUID,PKNAME|grep -oP "$BOOT_UUID\s\K.+")
BOOT_PARTN=$(lsblk -nro UUID,PARTN| grep -oP "$BOOT_UUID\s\K.+")
ROOT_UUID=$(grep -oP 'UUID=\S+(?=\s+\/\s)' /mnt/etc/fstab)
# SWAP_UUID=$(grep -oP 'UUID=\S+(?=.+?swap)' /mnt/etc/fstab)

LOCALE_GEN_MODIFY="sed -i -E 's/#($LOCALE_GEN)/\1/g' /etc/locale.gen"
MAKEPKG_CONF_MODIFY="sed -i -E -e's/^(COMPRESSZST=\(zstd -c -T0).*?( -\))/\1\2/' -e's/^#(MAKEFLAGS=.*)/\1/' /etc/makepkg.conf"
MKINITCPIO_CONF_MODIFY="sed -i -E -e's/^(HOOKS=\(base)/\1 plymouth/' /etc/mkinitcpio.conf"
SUDOERS_MODIFY="sed -i -E 's/# (Defaults env_keep \+= "HOME"|%wheel ALL=\(ALL:ALL\) ALL)/\1/g' /etc/sudoers"

BOOTCTL_LOADER_CONF="cat <<_EOF |tee /boot/loader/loader.conf
default arch-zen.conf
timeout 3
console-mode keep
editor no
_EOF
"
BOOTCTL_ENTRIES_ARCH_ZEN_CONF="cat <<_EOF |tee /boot/loader/entries/arch-zen.conf
title Arch Linux w/ ZEN Kernel *IMG*
linux /vmlinuz-linux-zen
initrd /initramfs-linux-zen.img
options root=$ROOT_UUID rw
options quiet splash
# options acpi.ec_no_wakeup=1
# options i915.enable_fbc=0 i915.enable_psr=0 i915.enable_dc=0
# options video=DSI-1:panel_orientation=right_side_up
_EOF
"
BOOTCTL_ENTRIES_WINDOWS_CONF="cat <<_EOF |tee /boot/loader/entries/windows.conf
title Windows
efi /shellx64.efi
options -nointerrupt -noconsolein -noconsoleout windows.nsh
_EOF
"
BOOT_WINDOWS_NSH="echo FS${WINDOWS_FSNUM}:EFI\\\\Microsoft\\\\Boot\\\\Bootmgfw.efi|tee /boot/windows.nsh"
ETC_CMDLINE_D="\
mkdir /etc/cmdline.d
echo 'root=$ROOT_UUID rw' |tee /etc/cmdline.d/10-root.conf
echo 'quiet splash' |tee /etc/cmdline.d/20-misc.conf
# echo 'acpi.ec_no_wakeup=1' |tee /etc/cmdline.d/30-ec_no_wakeup.conf
# echo 'i915.enable_fbc=0 i915.enable_psr=0 i915.enable_dc=0' |tee /etc/cmdline.d/30-i915.conf
"
MKINITCPIO_UKI_PRESET_ZEN="
cat <<_EOF |tee /etc/mkinitcpio.d/uki.preset
# mkinitcpio preset file for uki

PRESETS=('uki_zen')

uki_zen_uki=\"/boot/EFI/Linux/arch-zen.efi\"
uki_zen_kver=\"/boot/vmlinuz-linux-zen\"
uki_zen_options=\"--splash /sys/firmware/acpi/bgrt/image --osrelease /etc/osrel-zen-uki\"
_EOF

mkdir -p /etc/pacman.d/hooks
cat <<_EOF |tee /etc/pacman.d/hooks/uki.hook
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Operation = Remove
Target = usr/lib/initcpio/*
Target = usr/lib/firmware/*
Target = usr/src/*/dkms.conf
Target = usr/lib/systemd/systemd
Target = usr/bin/cryptsetup
Target = usr/bin/lvm

[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Target = usr/lib/modules/*/vmlinuz

[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = mkinitcpio
Target = mkinitcpio-git

[Action]
Description = Updating UKI...
When = PostTransaction
Exec = /usr/bin/mkinitcpio -p uki
_EOF

echo 'PRETTY_NAME=\"Arch Linux w/ ZEN Kernel *UKI*\"' |tee /etc/osrel-zen-uki
"
MKIITCPIO_DISABLE_ZEN_FALLBACK="
sed -i -E "s/\s*'fallback'//" /etc/mkinitcpio.d/linux-zen.preset
rm -f /boot/*-fallback.img
"
EFIBOOTMGR_UKI_ZEN="efibootmgr -d /dev/$BOOT_PKNAME -p $BOOT_PARTN -c -L arch-zen -l '\EFI\Linux\arch-zen.efi'"
BASH_HIST="cat <<_EOF |tee /home/$USER_NAME/.bash_history
bash <(curl -sL https://mcbeeringi.dev/dotfiles/kde.sh)
bash <(curl -sL https://mcbeeringi.dev/dotfiles/setup.sh)
_EOF
"

SYSTEMCTL_EN="systemctl enable systemd-networkd systemd-resolved iwd systemd-timesyncd bluetooth keyd"

cat <<EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
$LOCALE_GEN_MODIFY
locale-gen
echo LANG=$LOCALE_USE|tee /etc/locale.conf # localectl set-locale $LOCALE_USE
echo KEYMAP=$KEYMAP|tee /etc/vconsole.conf # localectl set-keymap $KEYMAP
$([[ $HOST_NAME ]] || echo '# ')echo $HOST_NAME|tee /etc/hostname
$PACMAN_CONF_MODIFY
$MAKEPKG_CONF_MODIFY
$MKINITCPIO_CONF_MODIFY

cp /usr/share/edk2-shell/x64/Shell_Full.efi /boot/shellx64.efi
bootctl update
$BOOTCTL_LOADER_CONF
$BOOTCTL_ENTRIES_ARCH_ZEN_CONF
$([[ $WINDOWS_FSNUM ]] && echo "${BOOTCTL_ENTRIES_WINDOWS_CONF}${BOOT_WINDOWS_NSH}")

$ETC_CMDLINE_D
$MKINITCPIO_UKI_PRESET_ZEN
$MKIITCPIO_DISABLE_ZEN_FALLBACK
pacman -S --noconfirm plymouth
$EFIBOOTMGR_UKI_ZEN

echo $ROOT_PASS|passwd -s root
useradd -m -g wheel -G input,uucp $USER_NAME
echo $USER_PASS|passwd -s $USER_NAME
$SUDOERS_MODIFY
$BASH_HIST

umount /etc/resolv.conf;ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf # RESOLV_CONF_LN
$SYSTEMCTL_EN
EOF

read -p "Press Enter to reboot..." ans;reboot
