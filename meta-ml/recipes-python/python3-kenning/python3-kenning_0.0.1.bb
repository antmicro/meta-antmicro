SUMMARY = "kenning"
DESCRIPTION = "Kenning - a framework for implementing and testing deployment pipelines for deep learning applications on edge devices"
HOMEPAGE = "https://github.com/antmicro/kenning"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5f65e8d2428eda0b797294f9c14f546d"

SRC_URI = "git://github.com/antmicro/kenning.git;protocol=https;branch=main;"
SRC_URI[sha256sum] = "3dc58c4533fda995933d5b1431a37fe3ff4f65994be1379d11011a7c468f6a61"
SRCREV = "1884718b4a66dbfb9639ed89cc0d700ad048ee63"

S = "${WORKDIR}/git"

inherit setuptools3

RDEPENDS:${PN} += " \
    python3-jinja2 \
    python3-pillow \
    python3-matplotlib \
    python3-numpy \
    python3-onnx \
    python3-scipy \
    python3-sklearn \
    python3-psutil \
    python3-tqdm \
"
