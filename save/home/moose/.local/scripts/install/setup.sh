#!/bin/sh

set -e

# only run with root permission
if [ "$EUID" -ne 0 ]; then Err "Install script must run with root privileges!"
    exit 1
fi

# ensure network connection
getent hosts archlinux.org
ping -c 5 archlinux.org

#==============================
# Util
#==============================
need() { command -v "$1" >/dev/null || { echo "Need $1"; exit 127; }; }
err() { echo "Error: $1" && exit 1 }

#==============================
# Variables
#==============================
DISK=""
TIMEZONE=""

ENCRYPT=false
PASSPHRASE=""
CRYPT_NAME=""

LVM=false
LVM_VG_NAME=""
LVM_ROOT_SIZE=""
LVM_SWAP_SIZE=""
LVM_HOME_SIZE=""

[[ -n "$DISK" || ! -e "$DISK" ]] && err "option DISK needs to be set and a valid block device"

BINARIES=`cat <<EOF
wipefs
sgdisk
udevadm
mkfs.fat
mkfs.ext4
mount
umount
arch-chroot
cp
EOF`
$ENCRYPT && BINARIES="$BINARIES cryptsetup"
$LVM && BINARIES="$BINARIES pvcreate lvcreate"
for b in $BINARIES; do need $b; done

#==============================
# Disk formatting
#==============================
read -p "This will erase all data on $DISK. Are you sure? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    err "Aborting..."
fi

# Wiping disk
wipefs --all --force "$DISK"
sgdisk --zap-all "$DISK"

# Create partitions
sgdisk -n 1:0:512M -t 1:ef00 -c 1:EFI "$DISK"   # UEFI boot partition
sgdisk -n 2:0:0    -t 2:8300 -c 2:cryptroot "$DISK"
partprobe "$DISK"

# Set base partition names
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

# format boot partition
mkfs.fat -F32 -n EFI "$EFI_PART"

# dm-crypt setup
if $ENCRYPT; then
	# Format luks partition
	cryptsetup luksFormat \
		--type luks2 \
		--cipher aes-xts-plain64 \
		--key-size 512 \
		--hash sha512 \
		"$ROOT_PART" <<EOF
YES
$PASSPHRASE
$PASSPHRASE
EOF

	# open for installation
	cryptsetup open --type=luks2 "$ROOT_PART" "$CRYPT_NAME" <<EOF
$PASSPHRASE
$PASSPHRASE
EOF
	ROOT_PART="/dev/mapper/$CRYPT_NAME"
fi

# LVM setup
if $LVM; then
    # Creating LVM structure
    LVM_PART="$ROOT_PART"
    pvcreate "$LVM_PART"
    vgcreate "$LVM_VG_NAME" "$ROOT_PART"
    lvcreate -L "$LVM_ROOT_SIZE" -n root "$LVM_VG_NAME"
    lvcreate -L "$LVM_SWAP_SIZE" -n swap "$LVM_VG_NAME"
    lvcreate -L "$LVM_HOME_SIZE" -n home "$LVM_VG_NAME"

    # Formatting LVM logical volumes
    mkfs.ext4 "/dev/$LVM_VG_NAME/root"
	mkswap "/dev/$LVM_VG_NAME/swap"
    mkfs.ext4 "/dev/$LVM_VG_NAME/home"

	# Mount system
    mount "/dev/$LVM_VG_NAME/root" /mnt
	swapon "/dev/$LVM_VG_NAME/swap"
	mkdir -p /mnt/home /mnt/boot
    mount "/dev/$LVM_VG_NAME/home" /mnt/home
	mount "$EFI_PART" /mnt/boot

	ROOT_PART="/dev/$LVM_VG_NAME/root"
else  # non LVM fallback
	mount "$ROOT_PART" /mnt
	mkdir -p /mnt/boot
	mount "$EFI_PART" /mnt/boot
fi

#==============================
# Bootstrap
#==============================
pacstrap -K linux linux-firmware base base-devel grub efibootmgr iwctl dhcpcd git vim
genfstab -U /mnt >> /mnt/etc/fstab

#==============================
# Post-install
#==============================
# base config
echo "$HOSTNAME" > /mnt/etc/hostname
ln -sf "/mnt/usr/share/zoneinfo/$TIMEZONE" /mnt/etc/localtime
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
echo "KEYMAP=us" > /mnt/etc/vconsole.conf

# network
tee /mnt/etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=false
EOF

# encrypt
root_uuid="$(blkid -s UUID -o value "$ROOT_PART")"
echo "$CRYPT_NAME UUID=$root_uuid none luks" > /mnt/etc/crypttab

# mkinitcpio hooks
add_hooks=""
$ENCRYPT && add_hooks="$add_hooks encrypt"
$LVM && add_hooks="$add_hooks lvm2"
sed -i "s/^HOOKS=.*/HOOKS=(base udev autodetect keyboard keymap modconf block $add_hooks filesystems)/" /mnt/etc/mkinitcpio.conf

# boot
sed -i "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$root_uuid:$CRYPT_NAME root=$ROOT_PART\"|" /etc/default/grub

#==============================
# Chroot
#==============================
arch-chroot /mnt /bin/bash <<EOF
# base config
mkinitcpio -P
hwclock --systohc
locale-gen

# services
systemctl enable iwd
systemctl enable dhcpcd

# temporary root password
passwd
pass
pass

# boot
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

EOF

echo "finished initial setup! rebooting"
umount -R /mnt
reboot
