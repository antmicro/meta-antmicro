SUMMARY = "Antmicro Base ML Image"
DESCRIPTION = "Recipe to build image with Kenning, TVM and Jetson support"

LICENSE = "Apache-2.0"

inherit antmicro-jetson-base-image

IMAGE_INSTALL:append = " \
    python3-tvm \
    python3-kenning \
"
