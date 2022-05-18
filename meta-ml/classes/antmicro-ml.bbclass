SUMMARY = "Meta Antmicro ML"
DESCRIPTION = "Class to build image with meta-antmicro/meta-ml support"

LICENSE = "Apache-2.0"

inherit meta-antmicro-base

IMAGE_INSTALL:append = " \
    python3-tvm \
    python3-kenning \
"
