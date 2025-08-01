FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RDFM_DEFAULT_LOGGER_CONFIG ?= "file://default_loggers.conf"
# Only install default config described by ${RDFM_DEFAULT_LOGGER_CONFIG} when
# rdfm-telemetry-default(it builds the default logger) exists in IMAGE_INSTALL
SRC_URI:append = " \
    ${@bb.utils.contains('IMAGE_INSTALL', 'rdfm-telemetry-default', d.getVar('RDFM_DEFAULT_LOGGER_CONFIG'), '', d)} \
"
