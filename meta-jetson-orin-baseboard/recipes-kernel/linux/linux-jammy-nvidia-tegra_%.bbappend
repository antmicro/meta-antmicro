# We use repo tool and manifests to manage versioning for our forks.
SRCREV=""
KBRANCH=""
SRC_URI = "git://${TOPDIR}/../sources/linux-jammy-nvidia-tegra/;nobranch=1;usehead=1;rev=HEAD \
           ${@'file://localversion_auto.cfg' if d.getVar('SCMVERSION') == 'y' else ''} \
           ${@'file://disable-fw-user-helper.cfg' if d.getVar('KERNEL_DISABLE_FW_USER_HELPER') == 'y' else ''} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'file://systemd.cfg', '', d)} \
           file://disable-module-signing.cfg \
"
S = "${WORKDIR}/git"

KBUILD_DEFCONFIG = "p3767_antmicro_job_defconfig"
