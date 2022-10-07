FILESEXTRAPATHS:prepend:riscv64 := "${THISDIR}/files:"
SRC_URI:append:riscv64 = " \
    file://0001-Define-bootargs.patch \
"
