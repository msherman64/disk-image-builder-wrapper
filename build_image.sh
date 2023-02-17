#!/bin/bash

set -e
set -o xtrace
set -o errexit
set -o nounset

# element settings via env vars
# export DIB_PYTHON_VERSION=3
# export LIBGUESTFS_BACKEND=direct
export DIB_RELEASE="${DIB_RELEASE:-focal}"    # ubuntu, ubuntu-minimal
export DIB_GRUB_TIMEOUT=0   # bootloader
# export DIB_BOOTLOADER_DEFAULT_CMDLINE=nofb nomodeset gfxpayload=text.
# export DIB_BOOTLOADER_SERIAL_CONSOLE=ttyS0,115200
export DIB_CLOUD_INIT_DATASOURCES="ConfigDrive, OpenStack"
export DIB_DHCP_TIMEOUT=10

export DIB_DEBOOTSTRAP_EXTRA_ARGS="--cache-dir ${APT_CACHE}"
# settings to pass via argument
ELEMENTS="block-device-efi vm cloud-init-datasources dhcp-all-interfaces ubuntu-minimal"
ARCH="${DIB_ARCH:-amd64}"
OUTPUT_FILE="/opt/image_output/${DIB_RELEASE}-${ARCH}.qcow2"

#TODO
# Cloud-init args, specify only config_drive + openstack, reduce timeout
# debian-networking, can we use networkmanager/netplan, is dhcp-all-interfaces needed?
# ensure network drivers installed, broadcom, intel, qlogic, mellanox
# serial console, send pre-boot logs and journal


disk-image-create \
  $ELEMENTS \
  --no-tmpfs \
  -t qcow2 \
  -a $ARCH \
  -o $OUTPUT_FILE
