# This is a copy of original recipe from 'meta-mender-community'
# https://github.com/mendersoftware/meta-mender-community

EXTRADEPS = ""
EXTRADEPS:tegra = " tegra-bup-payload dummy-fw-tools"
RDEPENDS:${PN} += "${EXTRADEPS}"
