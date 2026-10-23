SRC_REPO_T23X_DTS = "github.com/antmicro/antmicro-jetson-orin-baseboard-nvidia-t23x-public-dts.git;protocol=https"
SRC_REPO_NV_OOT = "github.com/antmicro/antmicro-jetson-orin-baseboard-nvidia-linux-oot.git;protocol=https"

SRCREV_nvidia-oot = "33b38cd489576ae5a6348721288b6cab0f7662de"
SRCREV_t23x-dts = "f20f6fa050afdf5851710d32e8e23718703c831d"

TEGRA_OOT_CAMERA_DRIVERS:append = " \
    ${KERNEL_MODULE_PACKAGE_PREFIX}kernel-module-nv-ov5640 \
    ${KERNEL_MODULE_PACKAGE_PREFIX}kernel-module-nv-ov9281 \
"
