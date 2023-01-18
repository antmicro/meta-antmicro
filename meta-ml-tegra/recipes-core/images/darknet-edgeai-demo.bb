DESCRIPTION = "Edge AI demos base image"

IMAGE_FEATURES:append = " \
    package-management \
    ssh-server-openssh \
    tools-debug \
    x11 \
    x11-base \
"

REQUIRED_DISTRO_FEATURES = "x11"

LICENSE = "Apache-2.0"

inherit core-image features_check

IMAGE_INSTALL:append = " \
    cudnn \
    darknet \
    darknet-demo-service \
    farshow \
    glfw \
    grabthecam \
    htop \
    nano \
    opencv \
    openssh \
    packagegroup-xfce-base \
    python3-pyvidctrl \
    rsync \
    sudo \
    tegra-tools \
    vim \
    x11vnc \
    xdotool \
"
