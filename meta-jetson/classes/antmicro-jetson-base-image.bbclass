SUMMARY = "Antmicro Base Jetson image"
DESCRIPTION = "Class to build image with meta-antmicro/meta-jetson support"

inherit antmicro-base-image

IMAGE_INSTALL:append = " \
    cudnn \
    tegra-tools \
"
