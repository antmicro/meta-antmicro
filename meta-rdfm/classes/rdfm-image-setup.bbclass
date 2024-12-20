# This class configures A/B partitioning for the target system's image


# Base directory where rootfs, bootfs and datafs block devices are located.
# This should usually be /dev/.
RDFM_DEVICE_DIR_BASE ??= "/dev/"
# Base name of the boot block device.
# Examples: vda, sda, nvme0n1p
RDFM_ROOTFS_PART_BASE ??= "sda"

# Boot partition number
RDFM_BOOT_PART_NUMBER ??= "1"
# Rootfs A partition number
RDFM_ROOTFS_A_PART_NUMBER ??= "2"
# Rootfs B partition number
RDFM_ROOTFS_B_PART_NUMBER ??= "3"
# Data partition number
RDFM_DATA_PART_NUMBER ??= "4"

# Name of the partition block device for bootfs.
# This usually contains boot data, such as DTS or U-boot ITB images.
# Example: sda1, nvme0n1p1
RDFM_PARTITION_BOOTFS   ??= "${RDFM_DEVICE_DIR_BASE}${RDFM_ROOTFS_PART_BASE}${RDFM_BOOT_PART_NUMBER}"
# Name of the partition block device for rootfs A slot.
# Example: sda2, nvme0n1p2
RDFM_PARTITION_ROOTFS_A ??= "${RDFM_DEVICE_DIR_BASE}${RDFM_ROOTFS_PART_BASE}${RDFM_ROOTFS_A_PART_NUMBER}"
# Name of the partition block device for rootfs B slot.
# Example: sda3, nvme0n1p3
RDFM_PARTITION_ROOTFS_B ??= "${RDFM_DEVICE_DIR_BASE}${RDFM_ROOTFS_PART_BASE}${RDFM_ROOTFS_B_PART_NUMBER}"
# Name of the partition block device for datafs.
# Persistent system data is stored on this partition.
# Example: sda4, nvme0n1p4
RDFM_PARTITION_DATAFS   ??= "${RDFM_DEVICE_DIR_BASE}${RDFM_ROOTFS_PART_BASE}${RDFM_DATA_PART_NUMBER}"


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

# Compatible device types
RDFM_DEVICE_TYPES_COMPATIBLE ??= "${MACHINE}"
# Device type string. This string is used by RDFM client to check
# if artifacts are compatible with the device.
RDFM_DEVICE_TYPE ??= "${MACHINE}"

# Name of the storage device on which the U-Boot environment is being stored
RDFM_UBOOT_ENV_STORAGE ??= "${RDFM_STORAGE_DEVICE}"
# Name of the storage device on which the U-Boot redundant environment is being stored
RDFM_UBOOT_ENV_STORAGE_REDUND ??= "${RDFM_UBOOT_ENV_STORAGE}"
# Partition containing kernel files on the main storage device.
# By default this variable is set to the U-Boot variable "mender_boot_part_hex"
# Which is set to the current active rootfs partition
RDFM_KERNEL_FILES_PARTITION ??= "\${mender_boot_part_hex}"
# Path in which the kernel files reside on the RDFM_KERNEL_FILES_PARTITION
RDFM_KERNEL_FILES_PREFIX ??= "/boot/"
# String of U-Boot commands that should run before RDFM U-Boot setup
RDFM_UBOOT_PRE_SETUP_COMMANDS ??= ""
# String of U-Boot commands that should run after RDFM U-Boot setup
RDFM_UBOOT_POST_SETUP_COMMANDS ??= ""

# Append our custom image types by default
inherit rdfm-artifactimg
inherit rdfm-image-type-datafs
inherit rdfm-image-type-rootfs
inherit rdfm-image-type-sdimg
IMAGE_FSTYPES += " rootfsimg datafsimg sdimg rdfm "
