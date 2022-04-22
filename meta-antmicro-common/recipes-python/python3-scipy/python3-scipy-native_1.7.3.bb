SUMMARY = "Scipy"
DESCRIPTION = "SciPy is an open-source software for mathematics, science, and engineering. It includes modules for statistics, optimization, integration, linear algebra, Fourier transforms, signal and image processing, ODE solvers, and more."

SRC_URI = "gitsm://github.com/scipy/scipy;protocol=https;branch=maintenance/1.7.x"
SRC_URI[sha256sum] = "02a2e159eb6e279fd2417a06f17790f855274486e3947690da58898572f3b8a1"
SRCREV = "59e6539cf80dc04b16b0f0ab52343381f0a7a2fa"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=d31204a91ddce3a76a81d09c6bf72614;"

inherit setuptools3 native

S = "${WORKDIR}/git"

DEPENDS += " \
    python3-numpy-native \
    python3-numpy \
    python3-pybind11-native \
    python3-pythran-native \
    openblas-native \
    lapack-native \
    chrpath-native \
"

RDEPENDS_${PN} += " \
    python3-numpy \
    lapack \
    python3-profile \
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
