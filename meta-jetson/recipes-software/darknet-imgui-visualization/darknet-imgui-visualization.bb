SUMMARY = "Fast, OpenGL-based YOLO object detection visualization with Darknet and Dear ImGui"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRCREV = "583bf953c83f6e350efbb75b64b44e125780d2d5"
SRC_URI = " \
    https://github.com/antmicro/darknet-imgui-visualization;protocol=https;branch=master \
"

SRC_URI[sha256sum] = "aab13a46b5c8896e893a4a45c685a9f936b5bc8e88c36ad6bd57715fc0050fd3"
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
