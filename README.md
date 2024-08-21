# dotfiles

[GitHub](https://github.com/mcbeeringi/dotfiles)

- dotfiles : ArchLinux + Hyprland & swayfx setup
	- home : chezmoi configs
	- root : non chezmoi configs
- install.sh : ArchLinux install script
- setup.sh : recommended packages setup script

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

[source](install.sh)

boot from the install media

```sh
loadkeys jp106

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
ROOT_PASS=password USER_NAME=user bash <(curl -s https://mcbeeringi.github.io/dotfiles/install.sh)
```

### setup.sh

[source](setup.sh)

login to sudo user

```sh

# run setup.sh
bash <(curl -s https://mcbeeringi.github.io/dotfiles/install.sh)
```
