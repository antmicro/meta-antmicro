DESCRIPTION = "Jetson Orin Baseboard demos base image"
LICENSE = "Apache-2.0"

inherit core-image nopackages

IMAGE_INSTALL:append = " \
	v4l-utils \
	i2c-tools \
	"
