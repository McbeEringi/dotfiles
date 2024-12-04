#!/bin/bash
[ $BLK ] || BLK='/dev/sda'
SWAP_SIZE=$(free -m|grep -oP 'Mem:\s+\K\d+'|awk '{printf "%.0f",$1*1.5}')
EFI=$(uuidgen)
SWAP=$(uuidgen)
ROOT=$(uuidgen)

sfdisk -d $BLK||$(echo label:gpt|sfdisk $BLK)
cat <<EOF | sfdisk -a $BLK
label: gpt
sector-size: 512

size=550MiB, type=U, uuid=$EFI
size=${SWAP_SIZE}MiB, type=S, uuid=$SWAP
type=L, uuid=$ROOT
EOF
sfdisk -r $BLK
ls /dev/disk/by-partuuid
sleep 1
ls /dev/disk/by-partuuid

mkfs.fat -F32 /dev/disk/by-partuuid/$EFI
mkswap /dev/disk/by-partuuid/$SWAP
mkfs.btrfs /dev/disk/by-partuuid/$ROOT

mount /dev/disk/by-partuuid/$ROOT /mnt
mount --mkdir /dev/disk/by-partuuid/$EFI /mnt/boot
swapon /dev/disk/by-partuuid/$SWAP
