FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://nvidia-drm.conf \
    file://monitor-hotplug.rules.in \
    file://monitor-hotplug.sh \
"

do_compile:append() {
    sed -e 's:@BINDIR@:${bindir}:' ${UNPACKDIR}/monitor-hotplug.rules.in > ${UNPACKDIR}/99-monitor-hotplug.rules
}

do_install:append() {
    install -d ${D}${sysconfdir}/modprobe.d/
    install -m 0644 ${UNPACKDIR}/nvidia-drm.conf ${D}/${sysconfdir}/modprobe.d
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${UNPACKDIR}/99-monitor-hotplug.rules ${D}/${sysconfdir}/udev/rules.d
    install -d ${D}${bindir}/
    install -m 0755 ${UNPACKDIR}/monitor-hotplug.sh ${D}/${bindir}/monitor-hotplug
}

FILES:${PN} += " \
    ${sysconfdir}/modprobe.d/nvidia-drm.conf \
    ${sysconfdir}/udev/rules.d/99-monitor-hotplug.rules \
    ${bindir}/monitor-hotplug \
"
