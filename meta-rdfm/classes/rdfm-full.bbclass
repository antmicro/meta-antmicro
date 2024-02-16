# Configuration for RDFM with all supported features enabled

MENDER_FEATURES_ENABLE:append = " \
    mender-image \
    mender-uboot \
    mender-client-install \
    mender-systemd \
"

inherit mender-setup
