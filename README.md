<div align="center">
  
# Totolink ax900 x900usm linux driver
  
[Install](#install) | [Troubleshooting](#troubleshooting) | [Uninstall](#uninstall)

![TOTOLINK](https://github.com/user-attachments/assets/81cd186a-665d-4513-8330-98189fd4655a)

</div>

> Tested on CachyOS with kernel 6.18.13-2-cachyos-lts
>
> Upstream driver support ubuntu 24.04 (linux kernel 6.14)

## Install

### Automated Installation

Run the provided script:

```bash
./install.sh
```

This will handle dependencies and installation automatically.

### Manual Installation

If you prefer manual steps:

#### 1. Install Dependencies

```bash
sudo pacman -S git dkms base-devel linux-headers bc usb_modeswitch
```

> `linux-headers` package name may vary based on your kernel. The main idea is to install the headers that match your current kernel version.

#### 2. Clone the Repository

```bash
git clone https://github.com/Keithsel/totolink-ax900-x900usm.git
cd totolink-ax900-x900usm
```

#### 3. Build and Install the Module

```bash
sudo dkms add .
sudo dkms build rtl8851bu/0.2
sudo dkms install rtl8851bu/0.2
```

#### 4. Handle USB Mode Switch

The adapter may initially appear as a USB storage device (ID `0bda:1a2b`). To switch to Wi-Fi mode:

- Unplug and replug the USB adapter.
- Alternatively, use `usb_modeswitch` if needed (device should auto-switch to ID `0bda:b831`).

#### 5. Load the Module

```bash
sudo modprobe 8851bu
```

#### 6. Enable Auto-Loading at Boot

```bash
echo "8851bu" | sudo tee /etc/modules-load.d/8851bu.conf
```

#### 7. Verify Installation

- Check interfaces: `ip a` or `iw dev` (look for `wlanX` with correct MAC).
- Connect to your wifi with the adapter.

## Troubleshooting

```bash
lsusb
lspci | grep -i network
ls /sys/class/net/
```

## Uninstall

```bash
sudo modprobe -r 8851bu
sudo dkms remove rtl8851bu/0.2 --all
sudo rm -f /etc/modules-load.d/8851bu.conf
sudo rm -rf /usr/src/rtl8851bu-0.2
```

## References

- [heesn/rtl8831](https://github.com/heesn/rtl8831)
- [tuanlda78202/totolink-ax900-x900usm](https://github.com/tuanlda78202/totolink-ax900-x900usm)
