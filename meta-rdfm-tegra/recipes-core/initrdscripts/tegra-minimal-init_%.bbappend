EXTRADEPS:tegra = ""
FILESEXTRAPATHS:prepend:tegra := "${THISDIR}/files:"
SRC_URI:append:tegra = " \
    file://0000-Kickstart-watchdog-in-initramfs.patch \
"
