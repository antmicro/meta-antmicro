DEPENDS:append:riscv64 = " python3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

include u-boot-rdfm-helpers.inc

SRC_URI:append:unmatched = " \
    file://0001-unmatched-integrate-rdfm.patch \
    file://unmatched.cfg \
"

SRC_URI:append:renodeunmatched = " \
    file://0001-unmatched-integrate-rdfm.patch \
    file://9999-renode-Remove-therm-sensor-initialization.patch \
    file://9999-renode-Enable-VirtIO-on-unmatched.patch \
    file://9999-renode-Add-generic-block-device-environment.patch \
    file://renodeunmatched.cfg \
"

SRC_URI:append = " \
    file://0001-Add-missing-header-which-fails-on-recent-GCC.patch \
    file://0002-Generic-boot-code-for-Mender.patch \
    file://0004-Switch-to-using-Mender-boot-command.patch \
    file://0005-Add-additional-bootargs.patch \
    file://0006-Add-support-for-boot-scripts.patch \
    file://0007-Add-boot-prefix.patch \
"

addtask do_provide_mender_defines after do_patch before do_configure
addtask do_create_uboot_env after do_compile before do_install
addtask do_uboot_auto_configure after do_provide_mender_defines before do_configure


do_uboot_auto_configure() {
    if [ -f ${WORKDIR}/*.cfg ]; then
        grep ".*=.*" ${WORKDIR}/*.cfg | while read -r line; do
            definition=$(echo $line | tr "=" "\t" | cut -f 1)
            value=$(echo $line | tr "=" "\t" | cut -f 2)

            redefine ${S} ${S}/configs/${UBOOT_MACHINE} ${definition} "${value}"
        done
    fi
    redefine ${S} ${S}/configs/${UBOOT_MACHINE} "CONFIG_ENV_SIZE" "${BOOTENV_SIZE}"
    redefine ${S} ${S}/configs/${UBOOT_MACHINE} "CONFIG_ENV_OFFSET" "${RDFM_ENV_OFFSET}"
    redefine ${S} ${S}/configs/${UBOOT_MACHINE} "CONFIG_ENV_OFFSET_REDUND" "${RDFM_ENV_OFFSET_REDUND}"
    redefine ${S} ${S}/configs/${UBOOT_MACHINE} "CONFIG_BOOTCOUNT_LIMIT" "y"
    redefine ${S} ${S}/configs/${UBOOT_MACHINE} "CONFIG_BOOTCOUNT_ENV" "y"
    redefine ${S} ${S}/configs/${UBOOT_MACHINE} "CONFIG_SYS_REDUNDAND_ENVIRONMENT" "y"
}

do_create_uboot_env() {
    cat > ${WORKDIR}/fw_env.config <<EOF
${RDFM_UBOOT_ENV_STORAGE}  ${RDFM_ENV_OFFSET}  ${BOOTENV_SIZE}
${RDFM_UBOOT_ENV_STORAGE_REDUND}  ${RDFM_ENV_OFFSET_REDUND}  ${BOOTENV_SIZE}
EOF
}

do_provide_mender_defines() {
    cat > ${S}/include/config_mender_defines.h <<EOF
/* AUTOGENERATED FILE - DO NOT EDIT! */
/* This file is provided by the meta-mender layer. */

#ifndef HEADER_CONFIG_MENDER_DEFINES_H
#define HEADER_CONFIG_MENDER_DEFINES_H

/* Shell variables */
#define MENDER_BOOT_PART_NUMBER ${RDFM_BOOT_PART_NUMBER}
#define MENDER_BOOT_PART_NUMBER_HEX ${@to_hex(RDFM_BOOT_PART_NUMBER)}
#define MENDER_ROOTFS_PART_A_NUMBER ${RDFM_ROOTFS_A_PART_NUMBER}
#define MENDER_ROOTFS_PART_A_NUMBER_HEX ${@to_hex(RDFM_ROOTFS_A_PART_NUMBER)}
#define MENDER_ROOTFS_PART_B_NUMBER ${RDFM_ROOTFS_B_PART_NUMBER}
#define MENDER_ROOTFS_PART_B_NUMBER_HEX ${@to_hex(RDFM_ROOTFS_B_PART_NUMBER)}
#define MENDER_UBOOT_STORAGE_INTERFACE "${@storage_type(d)}"
#define MENDER_UBOOT_STORAGE_DEVICE ${@storage_device(d)[0]}
#define RDFM_KERNEL_FILES_PARTITION "${RDFM_KERNEL_FILES_PARTITION}"
#define RDFM_KERNEL_FILES_PREFIX "${RDFM_KERNEL_FILES_PREFIX}"

/* BB variables. */
#define MENDER_STORAGE_DEVICE "${RDFM_STORAGE_DEVICE}"
#define MENDER_STORAGE_DEVICE_BASE "${@storage_device(d)[1]}"
#define MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1 ${RDFM_ENV_OFFSET}
#define MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2 ${RDFM_ENV_OFFSET_REDUND}
#define MENDER_ROOTFS_PART_A_NAME "${@storage_device(d)[1]}${RDFM_ROOTFS_A_PART_NUMBER}"
#define MENDER_ROOTFS_PART_B_NAME "${@storage_device(d)[1]}${RDFM_ROOTFS_B_PART_NUMBER}"

/* For sanity checks. */
#define MENDER_BOOTENV_SIZE ${BOOTENV_SIZE}

#define MENDER_BOOT_KERNEL_TYPE "${@get_rdfm_kernel_type(d)[1]}"
#define MENDER_KERNEL_NAME "${@get_rdfm_kernel_type(d)[0]}"
#define MENDER_DTB_NAME "${@get_rdfm_devicetree(d)}"
#define MENDER_UBOOT_PRE_SETUP_COMMANDS "${RDFM_UBOOT_PRE_SETUP_COMMANDS}"
#define MENDER_UBOOT_POST_SETUP_COMMANDS "${RDFM_UBOOT_POST_SETUP_COMMANDS}"
#define RDFM_ADDITIONAL_BOOTARGS "${RDFM_ADDITIONAL_BOOTARGS}"
#endif /* !HEADER_CONFIG_MENDER_DEFINES_H */
EOF
}
