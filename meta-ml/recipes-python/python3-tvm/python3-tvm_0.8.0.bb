SUMMARY = "Apache TVM"
DESCRIPTION = "Apache TVM is a compiler stack for deep learning systems. It is designed to close the gap between the productivity-focused deep learning frameworks, and the performance- and efficiency-focused hardware backends. TVM works with deep learning frameworks to provide end to end compilation to different backends."
HOMEPAGE = "https://tvm.apache.org/"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f30f7a1bcf7728eb568504d96cee7b09;"

SRC_URI = "git://github.com/apache/tvm.git;protocol=https;branch=v0.8;"
SRC_URI[sha256sum] = "7cb6c6563417b64ad0b71abe8899109380c91c0ab8c40cfe3e2569b6fcb6e724" 
SRCREV = "7b3a22e465dd6aca4729504a19beb4bc23312755"

S = ${WORKDIR}/git

inherit cmake

DEPENDS += " \
    python3-attrs \
    python3-decorator \
    python3-numpy \
    python3-psutil \
    python3-scipy \
    python3-synr \
    python3-tornado \
"

RDEPENDS_${PN} += " \
    python3-attrs \
    python3-decorator \
    python3-numpy \
    python3-psutil \
    python3-scipy \
    python3-synr \
    python3-tornado \
"
