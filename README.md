# My-Arch-Setup
This repo contains the easy step by step configuration for stting up arch on your single/dual boot setup.It contains the following main steps:

1.Downloading latest Arch-Linux iso

2.Creating a bootable USB 

3.Boot the live environment

4.Connect to network

5.Run the installer(GUIDED/MANUAL)

6.Post-install setup

# Downloading Latest Arch-linux iso
You can download the latest image from the official site → https://archlinux.org/download/

Scroll down to this section and select your region if available or in case  u want to keep it simple just use one of the global links as they work the same and only differ in download speed at most.
<img width="1643" height="1042" alt="image" src="https://github.com/user-attachments/assets/3fa74037-d71a-43c8-bed0-97f3e7c139e6" />

After clicking on one of the links (i used  → https://geo.mirror.pkgbuild.com/iso/2026.06.01/) select the option which suits you ( i used archlinux-2026.06.01-x86_64.iso  as it suited my purpose and is also one of the most widely used forms.)
<img width="850" height="358" alt="image" src="https://github.com/user-attachments/assets/29fd12d1-9ba2-4e08-a56e-41c27f9890d5" /> 

Now wait for the installation and move on to creating a bootable USB.

# Creating a bootable USB
Use a usb (ideally >= 4gb ) 

NOTE:- Make sure that u don't have any important data  on the USB  u have chosen or backup the data.

Install Rufus or BalenaEtcher for creating a bootable USB ,insert the USB and follow the steps on their official site. Access the official site for rufus for info regarding bootable usb → https://rufus.ie/en/  (the site contains all steps to make a bootable USB)

# Boot live environment 
For this step u need to disable SecureBoot (since arch ISO doesn't support it.)

Boot the USB via your boot menu (can be accessed by pressing f2 or f12 when u start your device). Then select the USB with loaded iso at bootloader. You will be greeted with the following screen. Select the desired option (first in most cases).


<img width="958" height="759" alt="image" src="https://github.com/user-attachments/assets/eadd6abe-787b-4597-a649-f0bc9dc55b3c" />


Give it some time and you'll reach the following screen
<img width="852" height="533" alt="image" src="https://github.com/user-attachments/assets/a6fb0e08-e135-47fc-abcf-5332e07b0aa9" />

# Connect to Network 
Since you won't have access to internet at this point arch provides u with some default ways.

```
iwctl  #enter interactive mode
device list
device wlan0 connect "YourWifiName"  #Replace with your adapter/name
exit
```
Then verify your connection using 
```
ping -c 3 archlinux.org
```

# Run the installer 
Now that you are connected to a netwrok lets move to the core steps. there are two ways to run the installer manual and guided.
Guided is generally faster.
```
archinstall
```

Select disk, filesystem (ext4/BTRFS), timezone, locale, username, and packages.The script handles partitioning, formatting, and base installation automatically.

Users who want full control over their system prefer the manual mode (recommended mode for learning ).

# Manual Installation

I'll list down the steps involved step wise but in case u want to  go in more detail u can follow the official guide → https://wiki.archlinux.org/title/Installation_guide

## Partitioning
The initial step is partitioning ( dividing your storage into one used to store your boot and one to store all data on your setup)
```
fdisk
# Create: EFI (512M to 1G, FAT32), Root (rest, BTRFS)
```
Usually dividing it into 2 parts is enough but if u want multiple drives then it is a good way to divide them before you have any data in your setup.
the EFI partition is usually around 1G and the remaining can be treated as a separate partition. 

## Format and mount
Lets take 2 partitions for a general case scenario (so all code regarding partitioning will be as such)

1) /dev/sda1 → EFI_systempartition
2) /dev/sda2 → root_partition
```
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```
If u have multiple drives for your data they'll be treated as .ext4 type . But beware to backup your data if u have any in a drive or if a drive belongs to some other os like in case of a dual boot. Don't touch partitions belonging to other Operating systems. U can see all partitions using following
```
lsblk -f
#or
fdisk -l
```
## Install base
Installs the base files.
```
pacstrap /mnt base linux linux-firmware
```
## Configure
First we create a system table so our partition boots automatically at boot and we don't need the USB.
```
genfstab -U /mnt >> /mnt/etc/fstab
```
All the remaining configuration will be done inside arch-chroot
```
arch-chroot /mnt
locale-gen
echo "Yourhostname" > /etc/hostname
passwd                              # this will set password for your root remember it!
useradd -m -G wheel "YourUser"      #used to add user to your setup
passwd "YourUser"                   #This will set the password for your user . It can be changed from root.
```
Now we install Bootloader (GRUB)
```
pacman -S grub
pacman -S efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```
Now lets install some tools we will need on reboot install them before reboot as u won't be able to proceed directly if u don't have them
```
pacman -S sudo
pacman -S networkmanager  # used to connect you to the network after reboot since iwctl won't work
systemctl enable NetworkManager
```
Now we can proceed to post installation
```
exit
umount -R /mnt
reboot
```

Congratulations you are all setup for arch , u can now remove the USB and enjoy arch although it was the core installation and it now enables you to install your desktop environments and other custom setups.
