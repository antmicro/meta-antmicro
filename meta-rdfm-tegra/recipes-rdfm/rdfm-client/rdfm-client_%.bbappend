# This is a copy of original recipe from 'meta-mender-community'
# https://github.com/mendersoftware/meta-mender-community

EXTRADEPS = ""
EXTRADEPS:tegra = " tegra-bup-payload rdfm-tegra-utils tegra-bootpart-config dummy-fw-tools tegra-boot-tools"
RDEPENDS:${PN} += "${EXTRADEPS}"
