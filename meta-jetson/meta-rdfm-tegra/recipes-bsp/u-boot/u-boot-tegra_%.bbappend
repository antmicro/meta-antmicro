FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove:mender-uboot = "file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI:remove:mender-uboot = "file://0010-tegra-mender-auto-configured-modified.patch"
SRC_URI:remove:mender-uboot = "file://0012-p3541-0000_defconfig-Mender-patch.patch"
SRC_URI:remove:mender-uboot = "file://0013-Reduce-env-size-on-p3450-0000-to-64KiB.patch"
SRC_URI:remove:mender-uboot = "file://0015-Update-TX1-nano-emmc-defconfigs-for-new-UBENV-locati.patch"

RDFM_PATCHES = " \
    file://0012-p3541-0000_defconfig-RDFM-patch.patch \
    file://0015-PATCH-Update-TX1-nano-emmc-defconfigs-for-new-UBENV.patch \
"
RDFM_PATCHES:l4t-mender-32-4-3 = ""
SRC_URI:append:mender-uboot = " file://0003-Integration-of-Rdfm-boot-code-into-U-Boot.patch"
SRC_URI:append:mender-uboot = " file://0010-tegra-rdfm-auto-configured-modified.patch"
SRC_URI:append:mender-uboot = " ${RDFM_PATCHES}"
