FILESEXTRAPATHS:prepend:riscv64 := "${THISDIR}/files:"
SRC_URI:append:riscv64 = " \
    file://0001-Define-bootargs.patch \
    file://0001-Integration-of-RDFM-boot-code-for-sifive-fu540.patch \
"
