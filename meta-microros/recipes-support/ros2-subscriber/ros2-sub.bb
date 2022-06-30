SUMMARY = "ros2_subscriber package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit ros_distro_galactic
inherit ros_superflore_generated
SRC_URI = "file://ros2_sub_src"
DEPENDS = " \
    ament-cmake \
    ament-cmake-libraries \
    ament-cmake-ros-native \
    ament-package \
    ament-cmake-python \
    builtin-interfaces \
    rmw \
    rcutils \
    rmw-fastrtps-shared-cpp \
    rosidl-default-runtime \
    micro-ros-agent \
"

RDEPENDS_${PN} = " \
    ament-cmake \
    builtin-interfaces \
    rmw \
    rcutils \
    rmw-fastrtps-shared-cpp \
    rosidl-default-runtime \
    micro-ros-agent \
"

S = "${WORKDIR}/ros2_sub_src"

FILES:${PN} += " \
    ${libdir}/* \
    ${datadir}/* \
"

inherit ros_ament_cmake