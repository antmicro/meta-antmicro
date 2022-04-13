SUMMARY = "Scipy"
DESCRIPTION = "SciPy is an open-source software for mathematics, science, and engineering. It includes modules for statistics, optimization, integration, linear algebra, Fourier transforms, signal and image processing, ODE solvers, and more."

SRC_URI = "gitsm://github.com/scipy/scipy;protocol=https;branch=maintenance/1.8.x"
SRC_URI[sha256sum] = "dc730324d4ac084d9cd67ca66d61c2ad4389ba46af1defbfd01f4fc1a369b5fd"
SRCREV = "b5d8bab88af61d61de09641243848df63380a67f"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=d31204a91ddce3a76a81d09c6bf72614;"

inherit setuptools3

S = "${WORKDIR}/git"

DEPENDS += " \
    python3-numpy-native \
    python3-numpy \
    python3-pybind11-native \
    python3-pythran-native \
    openblas \
    lapack \
    chrpath-native \
"

RDEPENDS_${PN} += " \
    python3-numpy \
    lapack \
"

export LAPACK = "${STAGING_LIBDIR}"
export BLAS = "${STAGING_LIBDIR}"

export F77 = "${TARGET_PREFIX}gfortran"
export F90 = "${TARGET_PREFIX}gfortran"

# Moving all the flags defined in LDSHARED to LDFLAGS
LDFLAGS:prepend := "${@" ".join(d.getVar("LDSHARED", True).split()[1:])} "
LDSHARED := "${@"".join(d.getVar("LDSHARED", True).split()[0])}"

LDFLAGS:append = " \
    -L${STAGING_LIBDIR}/${PYTHON_DIR}/site-packages/numpy/core/lib \
    -L${STAGING_LIBDIR}/${PYTHON_DIR}/site-packages/numpy/random/lib \
"

INSANE_SKIP_${PN} += "already-stripped"

do_install_append() {
    cd ${D}${libdir}/${PYTHON_DIR}/site-packages/scipy
    find . -type f -name "*.so" -exec chrpath -d "{}" \;
    cd -
}
