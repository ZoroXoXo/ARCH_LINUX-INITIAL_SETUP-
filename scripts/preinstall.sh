#!/usr/bin/env bash
set -Eeuo pipefail

echo "Arch Linux pre-install checklist"
echo "--------------------------------"
echo "1. Verify internet connection"
echo "2. Check disk layout"
echo "3. Confirm boot mode"
echo "4. Prepare partitions carefully"

echo
echo "Check internet:"
echo "  ping -c 3 archlinux.org"

echo
echo "List disks:"
echo "  lsblk -f"
echo "  fdisk -l"

echo
echo "For Wi-Fi:"
echo "  iwctl"
echo "  device list"
echo "  device wlan0 connect \"YourWifiName\""
echo "  exit"

echo
echo "Warning: Do NOT run formatting commands unless you are sure about the target disk."
