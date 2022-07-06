SUMMARY = "ros2_subscriber package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://../../LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

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

S = "${WORKDIR}/ros2_sub_src/src/ros2-sensor-subscriber/"

FILES:${PN} += " \
    ${libdir}/* \
    ${datadir}/* \
"

inherit ros_ament_cmake