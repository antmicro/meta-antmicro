DESCRIPTION = "Jetson Orin Baseboard demos base image"
LICENSE = "Apache-2.0"

inherit core-image nopackages

CORE_IMAGE_EXTRA_INSTALL = "l4t-usb-device-mode"
IMAGE_INSTALL:append = " \
	v4l-utils \
	i2c-tools \
	"
