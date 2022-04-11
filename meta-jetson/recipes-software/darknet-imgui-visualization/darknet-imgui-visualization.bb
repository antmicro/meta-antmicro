SUMMARY = "Fast, OpenGL-based YOLO object detection visualization with Darknet and Dear ImGui"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRCREV = "1cd566c5f53eab8cf59924d80079c4d0c283b454"
SRC_URI = " \
    https://github.com/antmicro/darknet-imgui-visualization;protocol=https;branch=master \
"

SRC_URI[sha256sum] = "dcaccec179fdcc83930c899bf11940bacba67a2611c0b223cb273a35388f6537"
S = "${WORKDIR}/git"

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
