SUMARRY = "Pythran"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e277a0b6033e0cb3d510c86b74144b01"

inherit setuptools3 pypi

SRC_URI[sha256sum] = "0b2cba712e09f7630879dff69f268460bfe34a6d6000451b47d598558a92a875"

BBCLASSEXTEND += "native"

RDEPENDS_${PN} += " \
    python3-ply \
    python3-gast \
    python3-numpy \
    python3-beniget \
"
