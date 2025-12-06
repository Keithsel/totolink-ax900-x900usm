#!/bin/bash

set -e

echo "Installing dependencies..."
echo "Are you using the standard Linux kernel? (y/n)"
read -r response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    sudo pacman -S --needed git dkms base-devel linux-headers bc usb_modeswitch
else
    echo "Please install the appropriate kernel headers for your kernel manually. For example, if using linux-lts, run: sudo pacman -S linux-lts-headers"
    sudo pacman -S --needed git dkms base-devel bc usb_modeswitch
fi

echo "Building and installing the module..."
sudo dkms add .
sudo dkms build rtl8851bu/0.2
sudo dkms install rtl8851bu/0.2

echo "Please unplug and replug the USB adapter to switch to Wi-Fi mode, then press Enter."
read -r -p ""

echo "Loading the module..."
sudo modprobe 8851bu

echo "Enabling auto-loading at boot..."
echo "8851bu" | sudo tee /etc/modules-load.d/8851bu.conf > /dev/null

echo "Installation complete. Check 'ip a' or 'iw dev' for the wlan interface."