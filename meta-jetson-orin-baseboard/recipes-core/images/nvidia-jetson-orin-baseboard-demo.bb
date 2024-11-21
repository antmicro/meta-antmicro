DESCRIPTION = "Jetson Orin Baseboard demos base image"
LICENSE = "Apache-2.0"

inherit core-image nopackages

IMAGE_FEATURES:append = " \
    package-management \
    ssh-server-openssh \
    x11 \
    x11-base \
    splash \
    x11-sato \
"

REQUIRED_DISTRO_FEATURES = "x11"

CORE_IMAGE_EXTRA_INSTALL = "l4t-usb-device-mode"
IMAGE_INSTALL:append = " \
    htop \
    python3-pyvidctrl \
    openssh \
    sudo \
    v4l-utils \
    vim \
    iperf3 \
    i2c-tools \
    devmem2 \
    python3-pip \
    tps65988-flash \
    gstreamer1.0 \
"
