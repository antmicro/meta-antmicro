FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-Silicon-Nvidia-Allow-OS-access-to-QSPI-flash.patch;patchdir=../edk2-nvidia/"

do_compile:append(){
    fdtput -t x ${B}/images/L4TConfiguration.dtbo /fragment@0/__overlay__/firmware/uefi/variables/gNVIDIAPublicVariableGuid/RootfsRedundancyLevel data 1000000
}
