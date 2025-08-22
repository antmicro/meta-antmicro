include ${@bb.utils.contains("IMAGE_INSTALL", "rdfm-telemetry-cpu-usage", "rdfm-client-demo-appends.inc", "", d)}
