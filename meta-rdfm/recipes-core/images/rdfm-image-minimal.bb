SUMMARY = "A small image just capable to test if rdfm works."

inherit core-image

LICENSE = "Apache-2.0"

IMAGE_INSTALL:append = " \
    nano \
"
