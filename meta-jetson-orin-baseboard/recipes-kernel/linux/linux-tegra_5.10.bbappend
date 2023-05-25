FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
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

LINUX_VERSION_EXTENSION = "-l4t-r35.2.1"
SRCBRANCH = "oe4t-patches${LINUX_VERSION_EXTENSION}"

SRCREV = "AUTOINC"
KBRANCH = "${SRCBRANCH}"

KBUILD_DEFCONFIG = "p3767_antmicro_job_defconfig"

# This is required to properly build the custom devicetree as this task removes
# the necessary changes in kernel-dts Makefile.
do_validate_branches[noexec] = "1"

# Configuration file comes with patches, so we need to apply patches before checking the config file
do_fixsource() {
    cd ${STAGING_KERNEL_DIR}
    for p in ${WORKDIR}/*.patch; do echo $p; patch -p1 < $p; done
}
addtask fixsource before do_kernel_metadata after do_kernel_checkout
do_patch[noexec] = "1"
