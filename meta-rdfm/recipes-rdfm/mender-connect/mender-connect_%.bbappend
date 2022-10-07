FILESEXTRAPATHS:prepend:riscv64 := "${THISDIR}/files:"
SRC_URI:append:riscv64 = " file://0001-Compatibility-with-go-narrowed-namespacing.patch"
RDEPENDS:${PN}:remove = "mender-client"
RDEPENDS:${PN}:append = "rdfm-client"

PTEST_ENABLED:riscv64 = "0"
