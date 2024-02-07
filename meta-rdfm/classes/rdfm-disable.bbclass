# Disable RDFM from the build

# When building other image recipes from the main BSP (for example:
# container rootfs), they will inherit the configuration from the
# main local.conf, and because RDFM must be already configured at
# that point, the containers will have it installed as well.
# This recipe can be inherited from those image recipes to prevent
# RDFM from being installed in the container.

MENDER_FEATURES_DISABLE = " \
    mender-image \
    mender-client-install \
"
