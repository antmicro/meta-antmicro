include ${@bb.utils.contains("IMAGE_INSTALL", "rdfm-telemetry-cpu-usage", "rdfm-telemetry-config-appends.inc", "", d)}
