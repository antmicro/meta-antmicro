SUMMARY = "Definitions for the ROS 2 msgs entities information used by micro-ROS to leverage its functionality to the same level as ROS 2, by means of a dedicated graph manager"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

ROS_BRANCH ?= "branch=galactic"
SRC_URI = "git://github.com/micro-ROS/micro_ros_msgs;${ROS_BRANCH};protocol=https"
SRCREV = "e3664463e78ae5d0c34d86be92d707b3d9dfd27d"
S = "${WORKDIR}/git"

inherit ros_distro_galactic
inherit ros_superflore_generated

DEPENDS = " \
    ament-cmake-ros-native \
    ament-lint-auto \
    ament-lint-common \
    rclcpp \
    rosidl-default-generators-native \
    rosidl-typesupport-fastrtps-cpp-native \
    rosidl-typesupport-fastrtps-c-native \
"

RDEPENDS_${PN} = " \
    rosidl-default-runtime \
"

inherit ros_ament_cmake