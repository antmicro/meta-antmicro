SUMMARY = "kenning"
DESCRIPTION = "Kenning - a framework for implementing and testing deployment pipelines for deep learning applications on edge devices"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5f65e8d2428eda0b797294f9c14f546d"

SRC_URI = "git://github.com/antmicro/kenning.git;protocol=https;"
SRC_URI[sha256sum] = "3dc58c4533fda995933d5b1431a37fe3ff4f65994be1379d11011a7c468f6a61"
SRCREV = "1884718b4a66dbfb9639ed89cc0d700ad048ee63"

S = "${WORKDIR}/git"

inherit setuptools3

DEPENDS += " \
    python3-jinja2 \
    python3-pillow \
    python3-numpy \
"

RDEPENDS_${PN} += " \
    python3-jinja2 \
    python3-pillow \
    python3-numpy \
"
