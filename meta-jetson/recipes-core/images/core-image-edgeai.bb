DESCRIPTION = "Edge AI demos base image"

IMAGE_FEATURES_append = " \
    package-management \
    ssh-server-openssh \
    tools-debug \
    x11 \
    x11-base \
"

REQUIRED_DISTRO_FEATURES = "x11"

LICENSE = "Apache-2.0" 

inherit core-image features_check

IMAGE_INSTALL_append = " \
    darknet-demo-service \
    cudnn \
    darknet \
    glfw \
    htop \
    nano \
    opencv \
    openssh \
    packagegroup-xfce-base \
    rsync \
    sudo \
    tegra-tools \
    vim \
    x11vnc \
    xdotool \
"

inherit extrausers
EXTRA_USERS_PARAMS = " \
    useradd -P antmicro antmicro; \
    usermod -a -G dialout,input,shutdown,video,sudo antmicro; \
    usermod -P root root; \
"

# Here we give sudo access to sudo members
update_sudoers(){
    sed -i 's/# %sudo/%sudo/' ${IMAGE_ROOTFS}/etc/sudoers
}

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers;"

