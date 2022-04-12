SUMMARY = "Scipy"
DESCRIPTION = "SciPy is an open-source software for mathematics, science, and engineering. It includes modules for statistics, optimization, integration, linear algebra, Fourier transforms, signal and image processing, ODE solvers, and more."

SRC_URI = "git://github.com/scipy/scipy;protocol=https;branch=maintenance/1.8.x"
SRC_URI[sha256sum] = "dc730324d4ac084d9cd67ca66d61c2ad4389ba46af1defbfd01f4fc1a369b5fd"
SRCREV = "b5d8bab88af61d61de09641243848df63380a67f"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=d31204a91ddce3a76a81d09c6bf72614;"

inherit setuptools3

S = "${WORKDIR}/git"

DEPENDS += " \
    python3-numpy-native \
    python3-pybind11-native \
    python3-pythran-native \
    openblas \
    lapack \
"

RDEPENDS_${PN} += " \
    python3-numpy \
    lapack \
"

do_configure_append() {
    cd ${S}
    git submodule update --init
}

export LAPACK = "${STAGING_LIBDIR}"
export OPENBLAS = "${STAGING_LIBDIR}"

export F77 = "${TARGET_PREFIX}gfortran"
export F90 = "${TARGET_PREFIX}gfortran"

# Moving all the flags defined in LDSHARED to LDFLAGS
LDFLAGS:prepend := "${@" ".join(d.getVar("LDSHARED", True).split()[1:])} "
LDSHARED := "${@"".join(d.getVar("LDSHARED", True).split()[0])}"
