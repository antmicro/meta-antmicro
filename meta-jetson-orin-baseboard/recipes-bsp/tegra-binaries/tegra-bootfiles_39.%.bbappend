do_compile:append() {
    install -Dm 0644 ${S}/../tegra234-mb2-bct-misc-p3767-0000-antmicro-job.dts ${S}/bootloader/tegra234-mb2-bct-misc-p3767-0000-antmicro-job.dts
    install -Dm 0644 ${S}/../tegra234-mb2-bct-misc-p3701-0000-antmicro-job.dts ${S}/bootloader/tegra234-mb2-bct-misc-p3701-0000-antmicro-job.dts
    install -Dm 0644 ${S}/../tegra234-mb2-bct-misc-p3701-0008-antmicro-job.dts ${S}/bootloader/tegra234-mb2-bct-misc-p3701-0008-antmicro-job.dts
    install -Dm 0644 ${S}/../tegra264-mb2-bct-misc-p3834-xxxx-antmicro.dts ${S}/bootloader/tegra264-mb2-bct-misc-p3834-xxxx-antmicro.dts
}
