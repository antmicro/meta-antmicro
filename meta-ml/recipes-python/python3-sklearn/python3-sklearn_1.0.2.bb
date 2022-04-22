SUMMARY = "Scikit-learn"
DESCRIPTION = "Scikit-learn is a Python module for machine learning built on top of SciPy."
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://COPYING;md5=d187f5bc5e3881c1255dc1489493aac8"

inherit setuptools3

SRC_URI += "gitsm://github.com/scikit-learn/scikit-learn;protocol=https;branch=1.0.X;"
SRC_URI[sha256sum] = "7881fd47985325c47b5ca995248d402c7f58a874377bee7651e607d49ceae940"
SRC_URI[md5sum] = "e9c24b695a72c32ce64c21ca8965a435"
SRCREV = "7e1e6d09bcc2eaeba98f7e737aac2ac782f0e5f1"
SRC_URI += " \
    file://0001-Removes-python-packages-checking.patch \
"

S = "${WORKDIR}/git"

DEPENDS += " \
    python3-numpy-native \
    python3-scipy-native \
"

RDEPENDS_${PN} += " \
    python3-numpy \
    python3-scipy \
    python3-joblib \
    python3-threadpoolctl \
"

do_compile_prepend() {
    export PYTHON_CROSSENV="TRUE"
}
