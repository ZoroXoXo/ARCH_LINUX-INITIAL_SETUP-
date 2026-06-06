#Initially connecting to network

iwctl  #enter interactive mode
device list
device wlan0 connect "YourWifiName"    #Replace with your adapter/name
exit
ping -c 3 archlinux.org

#Partitioning
fdisk                                  # Create: EFI (512M to 1G, FAT32), Root (rest, ext4)

#Format and mount

mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

lsblk -f
#or
fdisk -l

pacstrap /mnt base linux linux-firmware    #install base

genfstab -U /mnt >> /mnt/etc/fstab         #so that our partition boots auto 

arch-chroot /mnt
  locale-gen
  echo "Yourhostname" > /etc/hostname
  passwd                              # this will set password for your root remember it!
  useradd -m -G wheel "YourUser"      # used to add user to your setup
  passwd "YourUser"                   # This will set the password for your user . It can be changed from root.
  
  pacman -S grub
  pacman -S efibootmgr
  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
  grub-mkconfig -o /boot/grub/grub.cfg
  
  pacman -S sudo
  
  pacman -S networkmanager  # used to connect you to the network after reboot since iwctl won't work
  systemctl enable NetworkManager

  exit

umount -R /mnt
reboot
