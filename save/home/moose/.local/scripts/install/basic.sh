#!/bin/sh

set -e

DISK="/dev/nvme0n1"
HOSTNAME=""
TIMEZONE=""

# only run with root permission
if [ "$EUID" -ne 0 ]; then
	echo "ERROR: Install script must run with root privileges!"
    exit 1
fi

# ensure network connection
getent hosts archlinux.org
ping -c 5 archlinux.org

# ensure that disk exists
if [[ ! -e "$DISK" ]]; then
	echo "ERROR: device $DISK does not exist"
	exit 1
fi

read -p "This will erase all data on $DISK. Are you sure? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    err "Aborting..."
fi

# wiping disk
wipefs --all --force "$DISK"
sgdisk --zap-all "$DISK"

# create partitions
sudo sgdisk --new-gpt "$DISK"
sgdisk -n 1:0:512M -t 1:ef00 -c 1:EFI "$DISK"
sgdisk -n 2:0:0    -t 2:8300 -c 2:ROOT "$DISK"
partprobe "$DISK"

# set base partition names
EFI_PART=""
ROOT_PART=""
if [[ "$DISK" =~ nvme[0-9]+n[0-9]+$ ]] \
|| [[ "$DISK" =~ mmcblk[0-9]+$ ]] \
|| [[ "$DISK" =~ md[0-9]+$ ]]; then
    EFI_PART="${DISK}p1"
    ROOT_PART="${DISK}p2"
elif [[ "$DISK" =~ sd[a-z]+$ ]]; then
    EFI_PART="${DISK}1"
    ROOT_PART="${DISK}2"
else
    err "Unsupported disk type: $DISK"
fi

# format partitions
mkfs.fat -F32 -n EFI "$EFI_PART"
mkfs.ext4 "$ROOT_PART"

# mount partitions
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$EFI_PART" /mnt/boot

# bootstrap OS
pacstrap -K /mnt linux linux-firmware base base-devel grub efibootmgr iwd dhcpcd git vim
genfstab -U /mnt >> /mnt/etc/fstab

# modify config files
mkdir -p /etc/iwd
tee /etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=false
EOF

# chroot and basic config
arch-chroot /mnt /bin/bash <<EOF
set -e

# base config
echo "$HOSTNAME" > /etc/hostname
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen
echo "KEYMAP=us" > /etc/vconsole.conf

# services
systemctl enable iwd
systemctl enable dhcpcd

# temporary root password
# IMPORTANT! change root password after first install
passwd
pass
pass

# boot
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
EOF

echo
echo "basic installation done! welcome to arch linux :)"
