SUMMARY = "Micro XRCE-DDS Agent provides the DDS-XRCE protocol, that enables low power devices to connect to the DDS environment of ROS 2"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

inherit ros_distro_galactic
inherit ros_superflore_generated

SRC_URI = "git://github.com/eProsima/Micro-XRCE-DDS-Agent;branch=ros2;protocol=https"
SRCREV = "08a762d9d2b3326e4c9b19115109031a65ba8e2c"
DEPENDS = " \
    cmake-native \ 
    ament-cmake \
    builtin-interfaces \
    ninja-native \
    ament-cmake-native \ 
    ament-cmake-ros-native \
    rosidl-default-generators \
    ament-lint-auto \
    ament-lint-common \
    rosidl-typesupport-fastrtps-cpp \
    ament-cmake-gtest \
    builtin-interfaces \
    rmw \
    rcutils \
    rmw-fastrtps-shared-cpp \
    rmw-dds-common \
    micro-ros-msgs \
    fastcdr \
    spdlog \
"

RDEPENDS_${PN} = " \
    ament-cmake \
    rosidl-default-generators \
    ament-lint-auto \
    ament-lint-common \
    rosidl-typesupport-fastrtps-cpp \
    ament-cmake-gtest \
    builtin-interfaces \
    rmw \
    rcutils \
    rmw-fastrtps-shared-cpp \
    rmw-dds-common \
    micro-ros-msgs \
    fastcdr \ 
    spdlog \
"

S = "${WORKDIR}/git"

FILES:${PN} += " \
    ${libdir}/libmicroxrcedds_agent.so.2.1.1 \
"

FILES:${PN}-dev += " \
    ${libdir}/libmicroxrcedds_agent.so \
    ${libdir}/libmicroxrcedds_agent.so.2.1 \
"

EXTRA_OECMAKE = " \
    -DUAGENT_P2P_PROFILE:BOOL=OFF \
    -DUAGENT_USE_SYSTEM_FASTDDS:BOOL=ON \
    -DUAGENT_USE_SYSTEM_FASTCDR:BOOL=ON \
    -DUAGENT_CED_PROFILE:BOOL=OFF  \
    -DUAGENT_BUILD_EXECUTABLE:BOOL=OFF \
    -DUAGENT_LOGGER_PROFILE:BOOL=ON \
    -DUAGENT_ISOLATED_INSTALL:BOOL=OFF \
    -DUAGENT_USE_SYSTEM_LOGGER:BOOL=ON \
"

inherit ros_ament_cmake