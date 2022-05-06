FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://antmicro-wallpaper.jpg \
    file://xfce4-desktop.xml \
"

SAVED_DIR := "${THISDIR}"

do_install:append() {
    install -d ${D}${datadir}/backgrounds/antmicro/
    install ${SAVED_DIR}/xfdesktop/antmicro-wallpaper.jpg ${D}${datadir}/backgrounds/antmicro/antmicro-wallpaper.jpg
    install -d ${D}/home/root/.config/xfce4/xfconf/xfce-perchannel-xml
    install ${SAVED_DIR}/xfdesktop/xfce4-desktop.xml ${D}/home/root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
}

FILES_${PN} += " \
    ${datadir}/backgrounds/antmicro/antmicro-wallpaper.jpg \
    /home/root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml \
"
