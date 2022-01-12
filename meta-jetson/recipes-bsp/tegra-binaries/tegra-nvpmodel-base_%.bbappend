FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " file://nvpmodel.conf "

SAVED_DIR := "${THISDIR}"

do_install_append () {
    install -m 0644 ${SAVED_DIR}/files/nvpmodel.conf ${D}${sysconfdir}/nvpmodel.conf
    if [ -n "${NVPMODEL_CONFIG_DEFAULT}" ]; then
        sed -i -e "s/PM_CONFIG DEFAULT=[0-9]\+/PM_CONFIG DEFAULT=${NVPMODEL_CONFIG_DEFAULT}/" ${D}${sysconfdir}/nvpmodel.conf
    fi
}
