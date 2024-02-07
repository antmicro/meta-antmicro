DEPENDS += "rdfm-custom-flash-layout"
rdfm_PARTITION_FILE = "${STAGING_DATADIR}/rdfm-flash-layout/flash_rdfm.xml"
PARTITION_FILE = "${rdfm_PARTITION_FILE}"

PARTITION_FILE:tegra234 = "${S}/bootloader/${NVIDIA_BOARD}/cfg/${PARTITION_LAYOUT_TEMPLATE}"
PARTITION_FILE_EXTERNAL:tegra234 = "${rdfm_PARTITION_FILE}"
