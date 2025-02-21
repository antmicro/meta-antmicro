DESCRIPTION = "A recipe responbile for the configuration of the RDFM Linux client telemetry component"

# Script used for config validation and generation
SRC_URI = "file://merge_confs.py \
            "

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDFM_LOGGERS_BINDIR = "/opt/rdfm"

DEPENDS += " \
    python3-jsonschema-native \
"

require rdfm-telemetry.inc
