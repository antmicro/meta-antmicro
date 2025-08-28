# nvidia-kernel-oot from scarthgap branch only provides a recipe
# that uses the L4T driver sources package, which is hard to override.
# Below .inc is taken from the main branch, which allows specifying
# a git repository for nvidia-kernel-oot sources.
require nvidia-kernel-oot_git.inc

# To prevent Yocto from having to handle our forked nvidia-kernel-oot
# submodules, this recipe requires providing the nvidia-kernel-oot sources
# externally. We use repo tool and manifests to manage versioning.
FILESEXTRAPATHS:prepend := "${TOPDIR}/../sources:"
SRC_URI = "file://nvidia-kernel-oot/"
S = "${WORKDIR}/nvidia-kernel-oot"
PV = "36.4.4-antmicro-job+git"

TEGRA_OOT_CAMERA_DRIVERS:append = " ${KERNEL_MODULE_PACKAGE_PREFIX}kernel-module-rtl8852ce "
TEGRA_OOT_CAMERA_DRIVERS:append = " ${KERNEL_MODULE_PACKAGE_PREFIX}kernel-module-nv-ov5640 "
TEGRA_OOT_CAMERA_DRIVERS:append = " ${KERNEL_MODULE_PACKAGE_PREFIX}kernel-module-nv-ov9281 "
