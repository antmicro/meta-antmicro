SUMMARY = "Meta Antmicro Jetson"
DESCRIPTION = "Class to build image with meta-antmicro/meta-jetson support"

inherit meta-antmicro-base

IMAGE_INSTALL:append = " \
    cudnn \
    tegra-tools \
"
