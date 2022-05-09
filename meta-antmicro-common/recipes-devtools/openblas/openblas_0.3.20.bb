SUMMARY = "OpenBLAS"
DESCRIPTION = "OpenBLAS is an optimized BLAS (Basic Linear Algebra Subprograms) library based on GotoBLAS2 1.13 BSD version."
HOMEPAGE = "https://github.com/xianyi/OpenBLAS/"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5adf4792c949a00013ce25d476a2abc0;"

SRC_URI += "git://github.com/xianyi/OpenBLAS.git;protocol=https;branch=develop;"
SRC_URI[sha256sum] = "5fca91b22762ecfa1f43de1b0c6fad5a50305c72e3cca54c2d84767d3bf76ffc"
SRCREV = "0b678b19dc03f2a999d6e038814c4c50b9640a4e"

S = "${WORKDIR}/git"

inherit cmake

def get_target(d):
    import re
    target_arch = d.getVar("TARGET_ARCH", True)
    if re.match("aarch64$", target_arch): return 64
    elif re.match("x86_64$", target_arch): return 64
    elif re.match("aarch32$", target_arch): return 32
    elif re.match("i.86$", target_arch): return 32
    else: return 32

def get_binary(d):
    import re
    target_arch = d.getVar("TARGET_ARCH", True)
    if re.match("aarch64$", target_arch): return "ARMV8"
    elif re.match("aarch32$", target_arch): return "CORTEXA9"
    elif re.match("x86_64$", target_arch): return "ATOM"
    elif re.match("i.86$", target_arch): return "ATOM"
    else: return "CORTEXA15"

EXTRA_OEMAKE += " \
    HOSTCC=${BUILD_CC} \
    CROSS_SUFFIX=${TARGET_PREFIX} \
    TARGET=${@get_target(d)} \
    BINARY=${@get_binary(d)} \
    OPENBLAS_LIBRARY_DIR=${D}${libdir} \
    ONLY_CBLAS=1 \
    CROSS=1 \
"

BBCLASSEXTEND += "native"
