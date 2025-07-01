SUMMARY = "Multi-GPU CUDA stress test"
HOMEPAGE = "http://wili.cc/blog/gpu-burn.html"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=090209293ddf61f16b0e114228ddb6ea"

SRC_URI = " \
    git://github.com/wilicc/gpu-burn.git;protocol=https;branch=master \
    file://0001-Support-Yocto-build.patch \
    file://0002-Specify-alternate-kernel-path.patch \
"

PV = "20240409+git"
SRCREV = "9aefd7c0cc603bbc8c3c102f5338c6af26f8127c"

COMPATIBLE_MACHINE = "(tegra)"

inherit cuda

S = "${WORKDIR}/git"

EXTRA_OEMAKE = " \
    COMPARE_KERNEL=${datadir}/gpu-burn/compare.ptx \
    COMPUTE=${TEGRA_CUDA_ARCHITECTURE} \
    CUDAPATH=${CUDA_PATH} \
    IS_JETSON=true \
"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/gpu_burn ${D}${bindir}
    install -d ${D}${datadir}/gpu-burn
    install -m 0644 ${B}/compare.ptx ${D}${datadir}/gpu-burn/compare.ptx
}

FILES:${PN} += " \
    ${bindir}/gpu_burn \
    ${datadir}/gpu-burn/compare.ptx \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"

RDEPENDS:${PN} += " \
    tegra-tools-tegrastats \
"
