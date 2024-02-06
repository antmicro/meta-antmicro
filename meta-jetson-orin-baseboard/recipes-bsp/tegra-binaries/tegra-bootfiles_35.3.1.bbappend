do_install:append:tegra234() {
    install -d ${D}${datadir}/tegraflash
    install -m 0644 ${S}/../tegra234-mb2-bct-misc-p3767-0000-antmicro-job.dts ${D}${datadir}/tegraflash/
}
