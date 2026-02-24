#!/bin/bash

set -e

echo "Installing dependencies..."
headers_pkg=""
for kernel in linux-cachyos-lts linux-cachyos linux-lts linux; do
    if pacman -Q "$kernel" &>/dev/null; then
        headers_pkg="${kernel}-headers"
        echo "Detected kernel: $kernel"
        echo "Installing with $headers_pkg..."
        sudo pacman -S --needed git dkms base-devel "$headers_pkg" bc usb_modeswitch
        break
    fi
done

if [[ -z "$headers_pkg" ]]; then
    echo "Warning: No known kernel found. Please ensure you have installed the kernel headers for your kernel before proceeding."
fi

echo "Building and installing the module..."
sudo dkms add .
sudo dkms build rtl8851bu/0.2
sudo dkms install rtl8851bu/0.2

echo "Detecting interfaces before unplug..."
ifaces_before=$(find /sys/class/net -maxdepth 1 -type l -printf '%f\n' 2>/dev/null | sort)

echo "Please unplug and replug the USB adapter..."
read -r -p "Press Enter when done: "

ifaces_after=$(find /sys/class/net -maxdepth 1 -type l -printf '%f\n' 2>/dev/null | sort)
new_iface=$(comm -13 <(echo "$ifaces_before") <(echo "$ifaces_after") | head -1)

echo "Detected interface: ${new_iface:-none}"

echo "Loading the module..."
sudo modprobe 8851bu

echo "Enabling auto-loading at boot..."
echo "8851bu" | sudo tee /etc/modules-load.d/8851bu.conf > /dev/null

echo "Installation complete."
if [[ -n "$new_iface" ]]; then
    echo "WiFi interface available: $new_iface"
fi
echo "Check 'ip a' or 'iw dev' for wlan interface details."