FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI += " \
    file://0001-gpio-pca953x-introduce-support-for-nxp-pcal6408.patch \
    file://0002-nvidia-drivers-media-i2c-nv_ov5640-add-driver.patch \
    file://0003-nvidia-drivers-media-i2c-nv_ov5640-add-regulator-sup.patch \
    file://0004-nvidia-drivers-media-add-nvidia-no-sensor-bus-intros.patch \
    file://0005-nvidia-drivers-media-fix-kernel-panic-in-VI-channel-.patch \
    file://0006-nvidia-remove-obsolete-dt-bindings-leds.patch \
    file://0007-arch-arm64-configs-p3767_antmicro_job-enable-dynamic.patch \
    file://0008-nvidia-platform-t23x-add-tegra234-p3767-0000-antmicr.patch \
    "
SRCBRANCH = "oe4t-patches-l4t-r35.2.1"
SRCREV = "a0861582129bb67d377b471a86cd6e651aa53301"
KBRANCH = "${SRCBRANCH}"

KBUILD_DEFCONFIG = "p3767_antmicro_job_defconfig"
