#!/usr/bin/env bash
set -Eeuo pipefail

cat <<'EOF'
Example manual installation flow:

mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

locale-gen
echo "YourHostname" > /etc/hostname
passwd
useradd -m -G wheel YourUser
passwd YourUser

pacman -S grub efibootmgr sudo networkmanager
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
EOF
