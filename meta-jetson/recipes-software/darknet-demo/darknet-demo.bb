SUMMARY = "YOLO model inference demo" 

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI = "file://darknet-demo"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

S = "${WORKDIR}/darknet-demo"

inherit cuda cmake pkgconfig

DEPENDS += " \
    darknet \
    glfw \
    glew \
"
RDEPENDS_${PN} += " \ 
    darknet \
    glfw \
    glew \
"

EXTRA_OECMAKE = "-DLIBDARKNET_PATH=${WORKDIR}/recipe-sysroot/usr/lib/libdarknet.so"
TARGET_CXXFLAGS += " -I${WORKDIR}/recipe-sysroot/usr/include/darknet -pthread "
