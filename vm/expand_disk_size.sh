#!/bin/bash

# Tested with Debian 12 and proxmox using
# the helper scripts at:
# https://github.com/community-scripts/ProxmoxVE

# Check if parted is installed, if not install.
# Then exapnd disk to use all available space.

# Check if the script is run as root (or using sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

# Check if parted is installed, and install it if not
if ! command -v parted &> /dev/null; then
  echo "parted is not installed. Installing it now..."
    # Install parted based on the package manager
    if command -v apt-get &> /dev/null; then
        apt-get update && apt-get install -y parted
    elif command -v yum &> /dev/null; then
        yum install -y parted
    else
        echo "Could not determine package manager. Please install 'parted' manually."
        exit 1
    fi
fi

printf 'fix\n1\nyes\n-0' | parted /dev/sda resizepart 1 ---pretend-input-tty
echo "Reboot for the updates to take place!"
# reboot
   
# Finally run
#   apt-get install qemu-guest-agent -y && apt-get install -y mc
