<div align="center">

# Arch Linux Initial Setup

A beginner-friendly step-by-step guide for setting up **Arch Linux** on a **single-boot** or **dual-boot** system.

[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Guide-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](./LICENSE)
[![Post Install Setup](https://img.shields.io/badge/Post--Install-Repository-blueviolet?style=for-the-badge&logo=github)](https://github.com/ZoroXoXo/ARCH_LINUX-POST_INSTALL_SETUP-)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Download the ISO](#download-the-iso)
- [Create a Bootable USB](#create-a-bootable-usb)
- [Boot the Live Environment](#boot-the-live-environment)
- [Connect to the Network](#connect-to-the-network)
- [Guided Installation](#guided-installation)
- [Manual Installation](#manual-installation)
  - [Partitioning](#partitioning)
  - [Format and Mount](#format-and-mount)
  - [Install Base System](#install-base-system)
  - [Configure the System](#configure-the-system)
  - [Install the Bootloader](#install-the-bootloader)
  - [Install Essential Tools](#install-essential-tools)
  - [Finish Installation](#finish-installation)
- [Post-Install Setup](#post-install-setup)
- [Notes](#notes)

---

## Overview

This repository covers the main steps required to install Arch Linux:

1. Download the latest Arch Linux ISO
2. Create a bootable USB
3. Boot into the live environment
4. Connect to the internet
5. Install Arch Linux using either the guided or manual method
6. Continue with post-install customization

If you want to jump straight to the next stage, use the post-install repository:

[**Post-Install Setup Repository**](https://github.com/ZoroXoXo/ARCH_LINUX-POST_INSTALL_SETUP-)

---

## Download the ISO

Download the latest Arch Linux ISO from the official Arch Linux website:

[https://archlinux.org/download/](https://archlinux.org/download/)

Scroll to the mirror section and choose a regional or global mirror.

Example mirror:

[https://geo.mirror.pkgbuild.com/iso/2026.06.01/](https://geo.mirror.pkgbuild.com/iso/2026.06.01/)
<img width="1643" height="1042" alt="Screenshot 2026-06-06 211239" src="https://github.com/user-attachments/assets/03087fec-7563-400c-8b88-28e5debdb0c6" />


Example ISO file:

```text
archlinux-2026.06.01-x86_64.iso
```
<img width="850" height="358" alt="Screenshot 2026-06-06 211441" src="https://github.com/user-attachments/assets/9ad923ae-65c3-46d1-99cd-83df0f9df441" />


After downloading the ISO, proceed to creating a bootable USB.

---

## Create a Bootable USB

Use a USB drive with at least **4 GB** of storage.

> [!WARNING]
> Make sure the USB does not contain important data. Creating a bootable USB may erase everything on it.

Tools you can use:
- [Rufus](https://rufus.ie/en/)
- [BalenaEtcher](https://www.balena.io/etcher/)

Flash the downloaded Arch Linux ISO to the USB and wait until the process is complete.

---

## Boot the Live Environment

Before booting the installer:

- Disable **Secure Boot**, since the default Arch ISO does not support it
- Open your system boot menu, usually using **F2**, **F12**, **Esc**, or **Del**
- Select the USB drive containing the Arch Linux ISO

In most cases, choose the first boot option from the Arch boot menu.
<img width="958" height="759" alt="Screenshot 2026-06-06 221600" src="https://github.com/user-attachments/assets/9bf886f9-db07-4009-9680-b7f2d8a8ad00" />


After a short wait, the Arch live environment should load.
<img width="852" height="533" alt="Screenshot 2026-06-06 222025" src="https://github.com/user-attachments/assets/d192bae6-1c60-4c42-a344-1bcbf62e2ba0" />


---

## Connect to the Network

You need internet access before starting the installation.

### For Wi-Fi

```bash
iwctl
device list
device wlan0 connect "YourWifiName"
exit
```

### Other connection types

- Ethernet may connect automatically
- Mobile broadband can be managed with `mmcli`

Verify that internet access is working:

```bash
ping -c 3 archlinux.org
```

---

## Guided Installation

The guided installer is faster and easier for most users.

Run:

```bash
archinstall
```

You will be able to configure:

- Disk selection
- Filesystem such as `ext4` or `Btrfs`
- Timezone
- Locale
- Username
- Additional packages

The guided installer can automatically handle partitioning, formatting, and base installation.

If you want full control and a better learning experience, use the manual installation method instead.

---

## Manual Installation

For the official Arch Linux documentation, see:

[Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide)

---

### Partitioning

Partitioning means dividing your physical drive into logical sections.

A common simple layout is:

- **EFI partition**: 512 MB to 1 GB, FAT32
- **Root partition**: remaining space, usually `ext4` or `Btrfs`

Example:

```bash
fdisk /dev/sda
```

> [!CAUTION]
> Make sure you select the correct drive. Partitioning the wrong drive can destroy existing data.

---

### Format and Mount

Example partition layout:

- `/dev/sda1` → EFI system partition
- `/dev/sda2` → Root partition

```bash
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

To inspect your partitions before formatting:

```bash
lsblk -f
fdisk -l
```

If you are setting up a dual-boot system, do **not** format partitions that belong to another operating system.

---

### Install Base System

Install the base Arch Linux system:

```bash
pacstrap /mnt base linux linux-firmware
```

---

### Configure the System

Generate the filesystem table:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Enter the installed system:

```bash
arch-chroot /mnt
```

Then configure basic system settings:

```bash
locale-gen
echo "YourHostname" > /etc/hostname
passwd
useradd -m -G wheel YourUser
passwd YourUser
```

This will:
- Generate locales
- Set the hostname
- Set the root password
- Create a regular user
- Set the user password

---

### Install the Bootloader

Install GRUB and `efibootmgr`:

```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

> [!NOTE]
> This assumes a **UEFI** installation with the EFI partition mounted at `/boot`.

---

### Install Essential Tools

Install a few important packages before rebooting:

```bash
pacman -S sudo networkmanager
systemctl enable NetworkManager
```

This ensures you can use `sudo` and reconnect to the internet after rebooting.

---

### Finish Installation

Exit the chroot, unmount the installation, and reboot:

```bash
exit
umount -R /mnt
reboot
```

Remove the USB drive when prompted.

If everything worked correctly, your new Arch Linux installation should boot successfully.
<img width="1279" height="793" alt="Screenshot 2026-06-07 001001" src="https://github.com/user-attachments/assets/9e859e07-b827-4c63-ac31-699308bd59cb" />


---

## Post-Install Setup

After booting into Arch Linux, the next stage usually includes:

1. Updating the system
2. Setting up the user properly
3. Installing a desktop environment or window manager
4. Configuring networking
5. Installing drivers
6. Adding useful tools and packages

Continue here:

[**Arch Linux Post-Install Setup**](https://github.com/ZoroXoXo/ARCH_LINUX-POST_INSTALL_SETUP-)

---

## Notes

- This guide is intended for educational and practical use
- Be careful with partitioning and formatting commands
- Always verify drive names before running destructive commands

---
