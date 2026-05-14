#!/usr/bin/bash
TMPD="$(mktemp -d)"
trap 'rm -rf "$TMPD"' EXIT

git clone --depth=1 https://aur.archlinux.org/yay-bin $TMPD
cd $TMPD
makepkg -si --noconfirm
