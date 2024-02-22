FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " \
    file://0001-BootChainDxe-Don-t-fail-boot-chain-updates-for-statu.patch;patchdir=../edk2-nvidia/ \
    "

do_compile:append(){
    fdtput -t x ${B}/images/L4TConfiguration.dtbo /fragment@0/__overlay__/firmware/uefi/variables/gNVIDIAPublicVariableGuid/RootfsRedundancyLevel data 1000000
}
