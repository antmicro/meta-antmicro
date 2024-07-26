# This class configures A/B partitioning for the target system's image


# Base directory where rootfs, bootfs and datafs block devices are located.
# This should usually be /dev/.
RDFM_DEVICE_DIR_BASE ??= "/dev/"
# Base name of the boot block device.
# Examples: vda, sda, nvme0n1p
RDFM_ROOTFS_PART_BASE ??= "sda"
# Name of the partition block device for bootfs.
# This usually contains boot data, such as DTS or U-boot ITB images.
# Example: sda1, nvme0n1p1
RDFM_PARTITION_BOOTFS   ??= "${RDFM_ROOTFS_PART_BASE}1"
# Name of the partition block device for rootfs A slot.
# Example: sda2, nvme0n1p2
RDFM_PARTITION_ROOTFS_A ??= "${RDFM_ROOTFS_PART_BASE}2"
# Name of the partition block device for rootfs B slot.
# Example: sda3, nvme0n1p3
RDFM_PARTITION_ROOTFS_B ??= "${RDFM_ROOTFS_PART_BASE}3"
# Name of the partition block device for datafs.
# Persistent system data is stored on this partition.
# Example: sda4, nvme0n1p4
RDFM_PARTITION_DATAFS   ??= "${RDFM_ROOTFS_PART_BASE}4"


# Size of the bootfs partition on the boot device in KiB.
# This usually contains boot data, such as DTS or U-boot ITB images.
RDFM_PARTITION_SIZE_BOOTFS ??= "131072"
# Size of a single rootfs slot, in bytes. There will be two
# slots on the physical block device: A and B. Default to using
# IMAGE_ROOTFS_SIZE.
RDFM_PARTITION_SIZE_ROOTFS ??= "4194304"
# Default size of the datafs partition in KiB. This determines how much
# data is initially flashed to the data partition, even if the
# file system actually uses less.
# Regardless of this setting, the data partition is expanded on
# first boot to fill the remaining space on the device.
RDFM_PARTITION_SIZE_DATAFS ??= "524288"

# Append our custom image types by default
inherit rdfm-artifactimg
inherit rdfm-image-type-datafs
inherit rdfm-image-type-rootfs
inherit rdfm-image-type-sdimg
IMAGE_FSTYPES += " rootfsimg datafsimg sdimg rdfm "
