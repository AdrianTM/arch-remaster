#!/bin/bash

# Update CoW space in GRUB config for Arch live USB
# Usage: ./update-cow-space.sh <mount_point>

set -euo pipefail

ME=${0##*/}

fatal() { echo "$ME: error: $*" >&2; exit 1; }

usage() {
    cat <<USAGE
Usage: $ME <mount_point>

Update the CoW space parameter in GRUB config on a mounted Arch live USB.

Arguments:
  <mount_point>  Mount point of the USB boot partition (e.g., /mnt/usb)

Example:
  sudo $ME /mnt/usb
USAGE
}

if [[ $# -ne 1 ]]; then
    usage
    exit 1
fi

MOUNT_POINT=$1

# Check if mount point exists and is a directory
[[ -d $MOUNT_POINT ]] || fatal "Mount point '$MOUNT_POINT' is not a directory"

# Check for GRUB config
GRUB_CFG="$MOUNT_POINT/arch/boot/grub/grub.cfg"
[[ -f $GRUB_CFG ]] || fatal "GRUB config not found at $GRUB_CFG. Ensure the USB boot partition is mounted."

# Get total memory in GB
TOTAL_MEM_GB=$(free -g | awk 'NR==2 {print $2}')
echo "Total system memory: ${TOTAL_MEM_GB}GB"

# Suggest CoW size based on memory
if [[ $TOTAL_MEM_GB -lt 4 ]]; then
    SUGGESTED="512M"
elif [[ $TOTAL_MEM_GB -lt 8 ]]; then
    SUGGESTED="1G"
else
    SUGGESTED="2G"
fi

echo "Suggested CoW space: $SUGGESTED (adjust based on your needs)"
read -p "Enter CoW space size (e.g., 1G, 512M): " COW_SIZE

# Validate input (basic check)
[[ $COW_SIZE =~ ^[0-9]+[MG]$ ]] || fatal "Invalid size format. Use e.g., 1G or 512M"

# Check if read-write
if ! touch "$MOUNT_POINT/.test_write" 2>/dev/null; then
    echo "Partition is read-only, attempting to remount as RW..."
    # Find the device
    DEVICE=$(findmnt -n -o SOURCE "$MOUNT_POINT" 2>/dev/null)
    [[ -n $DEVICE ]] || fatal "Could not determine device for $MOUNT_POINT"
    mount -o remount,rw "$DEVICE" "$MOUNT_POINT" || fatal "Failed to remount $DEVICE as RW"
    echo "Remounted as RW"
else
    rm -f "$MOUNT_POINT/.test_write"
fi

# Backup GRUB config
cp "$GRUB_CFG" "$GRUB_CFG.bak"
echo "Backed up GRUB config to $GRUB_CFG.bak"

# Update GRUB config: add cow_spacesize if not present
if grep -q "cow_spacesize" "$GRUB_CFG"; then
    echo "cow_spacesize already present, updating..."
    sed -i "s/cow_spacesize=[^ ]*/cow_spacesize=$COW_SIZE/" "$GRUB_CFG"
else
    echo "Adding cow_spacesize parameter..."
    sed -i "s|linux  /arch/boot/|linux  /arch/boot/ cow_spacesize=$COW_SIZE |" "$GRUB_CFG"
fi

echo "Updated GRUB config with cow_spacesize=$COW_SIZE"
echo "Reboot the USB to apply changes."