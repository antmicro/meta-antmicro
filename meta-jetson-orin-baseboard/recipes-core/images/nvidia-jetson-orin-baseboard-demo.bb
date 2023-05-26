DESCRIPTION = "Jetson Orin Baseboard demos base image"
LICENSE = "Apache-2.0"

inherit core-image nopackages

IMAGE_FEATURES:append = " \
    package-management \
    ssh-server-openssh \
"

CORE_IMAGE_EXTRA_INSTALL = "l4t-usb-device-mode"
IMAGE_INSTALL:append = " \
    htop \
    i2c-tools \
    python3-pyvidctrl \
    openssh \
    v4l-utils \
    vim \
"
