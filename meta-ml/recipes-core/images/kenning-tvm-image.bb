SUMMARY = "Antmicro Base ML Image"
DESCRIPTION = "Recipe to build image containing Kenning and TVM BSPs"

LICENSE = "Apache-2.0"

inherit antmicro-base-image

IMAGE_INSTALL:append = " \
    python3-tvm \
    python3-kenning \
"
