SUMMARY = "Micro-ROS Agent is a ROS 2 node that wraps the Micro XRCE-DDS Agent and aids in connecting micro-ROS devices to the ROS 2 ecosystem"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit ros_distro_galactic
inherit ros_superflore_generated

SRC_URI = "git://github.com/micro-ROS/micro-ROS-Agent;branch=galactic;protocol=https"
SRCREV = "52b35ef2eb9ea24bced342f6fc27f881ae5600cb"
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
    microxrcedds-agent \
    rosidl-cmake \
    rosidl-adapter \
    graph-msgs \
    micro-ros-diagnostic-msgs \
    rosidl-typesupport-fastrtps-cpp-native \
    rosidl-typesupport-fastrtps-c-native \
"

RDEPENDS:${PN} = " \
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
    microxrcedds-agent \
    rosidl-cmake \
    rosidl-adapter \
    graph-msgs \
    micro-ros-diagnostic-msgs \
    rosidl-default-runtime \
"

S = "${WORKDIR}/git/micro_ros_agent"


EXTRA_OECMAKE = " \
    -DMICROROSAGENT_SUPERBUILD:BOOL=OFF \
    -DUROSAGENT_GENERATE_PROFILE:BOOL=OFF \
"

inherit ros_ament_cmake
