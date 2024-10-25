# dotfiles

[GitLab](https://gitlab.com/mcbeeringi/dotfiles)

- dotfiles : ArchLinux + Hyprland & sway setup
	- home : chezmoi configs
	- root : non chezmoi configs
- install.sh : ArchLinux install script
- setup.sh : Hypeland with recommended packages setup script
- kde.sh : KDE Plasma setup script
- part.sh : partition setup script ***EXPERIMENTAL*** ***USE AT YOUR OWN RISK***

also includes niri & river(kanshi for monitor mng) configs

## Usage

### dotfiles

#### home

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

### install.sh

Install ArchLinux

[source](install.sh)

boot from the install media

```sh
loadkeys jp106
iwctl

# create partition, format mount
lsblk
cfdisk

mkfs.fat -F32 /dev/~
mkfs.ext4 /dev/~
mkswap /dev/~

swapon /dev~
mount /dev/~ /mnt
mount --mkdir /dev/~ /mnt/boot


# run install.sh
# see source for more options
ROOT_PASS=password USER_NAME=user bash <(curl -s https://mcbeeringi.dev/dotfiles/install.sh)
```

then [`setup.sh`](#setupsh) or [`kde.sh`](#kdesh)

### setup.sh

Setup Hyprland DE with recommended packages

[source](setup.sh)

login to sudo user

```sh

# run setup.sh
# can call from history
bash <(curl -s https://mcbeeringi.dev/dotfiles/setup.sh)
```

### kde.sh

Setup KDE Plasma DE

[source](kde.sh)

login to sudo user

```sh

# run kde.sh
# can call from history
bash <(curl -s https://mcbeeringi.dev/dotfiles/kde.sh)
```

### part.sh
***EXPERIMENTAL***

***USE AT YOUR OWN RISK***

[source](part.sh)

boot from the install media

```sh
loadkeys jp106
iwctl

# create partition, format mount
BLK=/dev/nvme0n1 bash <(curl -s https://mcbeeringi.dev/dotfiles/part.sh)

# run install.sh
ROOT_PASS=password USER_NAME=user bash <(curl -s https://mcbeeringi.dev/dotfiles/install.sh)
```
