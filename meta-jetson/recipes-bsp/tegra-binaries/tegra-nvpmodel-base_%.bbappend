FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " file://nvpmodel-xavier-nx.conf "

SAVED_DIR := "${THISDIR}"

do_install:append:jetson-xavier-nx-devkit () {
    install -m 0644 ${SAVED_DIR}/files/nvpmodel-xavier-nx.conf ${D}${sysconfdir}/nvpmodel.conf
    if [ -n "${NVPMODEL_CONFIG_DEFAULT}" ]; then
        sed -i -e "s/PM_CONFIG DEFAULT=[0-9]\+/PM_CONFIG DEFAULT=${NVPMODEL_CONFIG_DEFAULT}/" ${D}${sysconfdir}/nvpmodel.conf
    fi
}

do_install:append:jetson-xavier-nx-devkit-emmc () {
    install -m 0644 ${SAVED_DIR}/files/nvpmodel-xavier-nx.conf ${D}${sysconfdir}/nvpmodel.conf
    if [ -n "${NVPMODEL_CONFIG_DEFAULT}" ]; then
        sed -i -e "s/PM_CONFIG DEFAULT=[0-9]\+/PM_CONFIG DEFAULT=${NVPMODEL_CONFIG_DEFAULT}/" ${D}${sysconfdir}/nvpmodel.conf
    fi
}
