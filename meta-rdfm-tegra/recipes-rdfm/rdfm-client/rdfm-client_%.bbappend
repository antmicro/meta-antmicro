# This is a copy of original recipe from 'meta-mender-community'
# https://github.com/mendersoftware/meta-mender-community

EXTRADEPS = ""
EXTRADEPS:tegra = " tegra-fw-tools "
RDEPENDS:${PN} += "${EXTRADEPS}"

RDFM_BOOT_UTILS_GETENV_OVERRIDE:tegra = "rdfm-tegra-printenv"
RDFM_BOOT_UTILS_SETENV_OVERRIDE:tegra = "rdfm-tegra-setenv"
