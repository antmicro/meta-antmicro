SUMMARY = "Multi-GPU CUDA stress test"
HOMEPAGE = "http://wili.cc/blog/gpu-burn.html"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=090209293ddf61f16b0e114228ddb6ea"

SRC_URI = " \
    git://github.com/wilicc/gpu-burn.git;protocol=https;branch=master \
    file://0001-Change-compiler.patch \
    file://0002-Fix-static-rpaths.patch \
    file://0003-Configure-default-kernel-path.patch \
    file://0004-Fix-CUDA-13-compatibility.patch \
"

PV = "20240409+git"
SRCREV = "9aefd7c0cc603bbc8c3c102f5338c6af26f8127c"

DEPENDS = " \
    cuda-compiler-native \
    cuda-libraries-native \
"

inherit cuda

CUDA_PATH = "/usr/local/cuda-${CUDA_VERSION}"
CC_FIRST = "${@cuda_extract_compiler('CC_FOR_CUDA', d)[0]}"
CC_REST = "${@cuda_extract_compiler('CC_FOR_CUDA', d, prefix='')[1]}"
CFLAGS += "-I=${CUDA_PATH}/include"
EXTRA_NVCCFLAGS = "-I${STAGING_DIR_HOST}${CUDA_PATH}/include"

EXTRA_OEMAKE = ' \
    CUDAPATH="${STAGING_DIR_HOST}/${CUDA_PATH}" \
    CFLAGS="${CC_REST} ${CFLAGS}" \
    NVCC="${STAGING_DIR_NATIVE}/${CUDA_PATH}/bin/nvcc" \
    NVCCFLAGS="${CUDAFLAGS} -ccbin ${CC_FIRST} ${CUDA_NVCC_PATH_FLAGS} ${EXTRA_NVCC_FLAGS}" \
    IS_JETSON=true \
    KERNEL="${datadir}/gpu-burn/compare.ptx" \
    COMPUTE=87 \
'

do_install() {
    install -d ${D}${bindir} ${D}${datadir}/gpu-burn
    install -m 0755 ${B}/gpu_burn ${D}${bindir}
    install -m 0644 ${B}/compare.ptx ${D}${datadir}/gpu-burn
}
