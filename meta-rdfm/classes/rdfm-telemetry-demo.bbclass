inherit rdfm-rootfs-setup
inherit rdfm-image-setup

RDFM_MGMT_HOST_ADDRESS = "192.168.230.1"
RDFM_DEV_HOST_ADDRESS = "192.168.230.2"
MENDER_SERVER_URL = "https://${RDFM_MGMT_HOST_ADDRESS}:5000"
RDFM_TELEMETRY_BOOTSTRAP_SERVERS = "${RDFM_MGMT_HOST_ADDRESS}:9093"
RDFM_TELEMETRY_BATCH_SIZE = "512"
RDFM_TELEMETRY_LOG_LEVEL = "ERROR"

DISTRO_FEATURES:append = " rdfm-telemetry"
IMAGE_INSTALL:append = " rdfm-telemetry-cpu-usage"
IMAGE_INSTALL:remove = "rdfm-telemetry-default"
