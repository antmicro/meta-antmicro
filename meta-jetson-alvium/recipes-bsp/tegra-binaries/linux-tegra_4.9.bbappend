FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI += " file://0001-Add-Allied-Vision-camera-driver.patch "

KBUILD_DEFCONFIG = "tegra_allied_vision_defconfig"

