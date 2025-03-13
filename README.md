# dotfiles

- [dotfiles](#dotfiles-1) : [ArchLinux](https://archlinux.org) + [Hyprland](https://hyprland.org) & [sway](https://swaywm.org) setup
	- home : [chezmoi](https://chezmoi.io) configs
	- root : non chezmoi configs
- [part.sh](#partsh) : partition setup script
- [install.sh](#installsh) : ArchLinux install script
- [setup.sh](#setupsh) : dotfile setup script with recommended packages
- [kde.sh](#kdesh) : [KDE Plasma](https://kde.org/plasma-desktop/) setup script

also includes donfigs for additional WM

- [niri](https://github.com/YaLTeR/niri)
- [river](https://codeberg.org/river/river)
    - [kanshi](https://gitlab.freedesktop.org/emersion/kanshi) for monitor mng
- [labwc](https://labwc.github.io/)
    - kanshi for mon mng

## dotfiles

### home

```sh
# install chezmoi & init
which chezmoi || yay -Sy chezmoi
chezmoi init mcbeeringi

# apply
chezmoi apply
```

### root

```sh
chezmoi cd
sudo cp -r root/* / 
```

## part.sh

Create, format and mount partitions from empty space.

[source](part.sh)

root partition will be formatted with btrfs.

For usage, refer to [`install.sh`](#installsh) section.

### args
- BLK: block device path
  default is `/dev/sda`.
  ex:`BLK=/dev/nvme0n1`
- SWAP: swap creation flag
  set any value (including empty) to activate.
  default is unset. 
  ex: `SWAP=1`

## install.sh

Install ArchLinux and basic packages.

[source](install.sh)

boot from the install media

```sh
loadkeys jp106
iwctl

# part.sh : create partition, format mount
BLK=/dev/nvme0n1 bash <(curl -s https://mcbeeringi.dev/dotfiles/part.sh)
# set SWAP to any value (including enpty) to make swap
# BLK=/dev/nvme0n1 SWAP=1 bash <(curl -s https://mcbeeringi.dev/dotfiles/part.sh)

# or do manually
#
# lsblk
# cfdisk
#
# mkfs.fat -F32 /dev/~
# mkfs.ext4 /dev/~
# mkswap /dev/~
#
# swapon /dev~
# mount /dev/~ /mnt
# mount --mkdir /dev/~ /mnt/boot


# install.sh : install archlinux
ROOT_PASS=password USER_NAME=user bash <(curl -s https://mcbeeringi.dev/dotfiles/install.sh)
```

### args
- ROOT_PASS: password for root
  default is `password`
- USER_NAME: username for new user
  default is `user`
- USER_PASS: password for new user
  default is $ROOT_PASS
- TIMEZONE: timezone
  default is `Asia/tokyo`
- LOCALE_GEN: locales to generate
  pipe separated no whitespace list.
  default is `en_US.UTF-8|ja_JP.UTF-8`
- LOCALE_USE: locale to use
  default is `ja_JP.UTF-8`
- KEYMAP: keymap for virtual console
  default is `jp106`
- MIRROR_COUNTRY: country name to filter package server
  default is `Japan`
- CPU_VENDOR: for ucode determination
  `intel` or `amd`
  auto detected from /proc/cpuinfo
- GPU_VENDOR: for gpu related packages determination
  `intel` or `amd`
  auto detected from lspci
- HOST_NAME: hostname
  default is unset
- WINDOWS_BLKNUM: block device number (partition number) of windows EFI partition
  add boot entry for windows to systemd-boot.
  if you already installed windows, set this to `1`.
  default is unset

Run [`setup.sh`](#setupsh) or [`kde.sh`](#kdesh) after reboot.
Can be called from history.

## setup.sh

Setup Hyprland & sway with recommended packages.

[source](setup.sh)

```sh
bash <(curl -s https://mcbeeringi.dev/dotfiles/setup.sh)
```

## kde.sh

Setup KDE Plasma DE with neccesaries.

[source](kde.sh)

```sh
bash <(curl -s https://mcbeeringi.dev/dotfiles/kde.sh)
```

