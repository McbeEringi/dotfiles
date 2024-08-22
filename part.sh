#!/bin/bash
[ $BLK ] || BLK='/dev/sda'
SWAP_SIZE=$(free -m|grep -oP 'Mem:\s+\K\d+'|awk '{printf "%.0f",$1*1.5}')
EFI=$(uuidgen)
SWAP=$(uuidgen)
ROOT=$(uuidgen)

cat <<EOF | sfdisk -a $BLK
label: gpt
sector-size: 512

size=550MiB, type=U, uuid=$EFI
size=${SWAP_SIZE}MiB, type=S, uuid=$SWAP
type=L, uuid=$ROOT
EOF
sfdisk -r

mkfs.fat -F32 /dev/disk/by-uuid/$EFI
mkswap /dev/disk/by-uuid/$SWAP
mkfs.ext4 /dev/disk/by-uuid/$ROOT

mount /dev/disk/by-uuid/$ROOT /mnt
mount --mkdir /dev/disk/by-uuid/$EFI /mnt/boot
swapon /dev/disk/by-uuid/$SWAP
