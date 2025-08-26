inherit_defer ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'update-rc.d', '', d)}

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://template.sysvinit \
"

INITSCRIPT_PACKAGES ?= "${PN}"
INITSCRIPT_NAME ?= "haveged"
INITSCRIPT_PARAMS:${PN} ?= "defaults 9"

DIR ?= "/home/root"
CMD ?= "${sbindir}/haveged -w 1024 -r 0 -v 1"
USER ?= "root"
FILENAME ?= "haveged"

python do_check_vars () {
    """
    Check if all the required datastore variables for this recipe are present
    """
    if not bb.utils.contains("DISTRO_FEATURES", "sysvinit", True, False, d):
        return
}

python do_check_vars:append () {
    required_vars = ["DIR", "CMD", "USER", "FILENAME"]
    missing = [v for v in required_vars if not d.getVar(v)]
    if missing:
        bb.fatal("Missing required variables for do_check_vars: %s" % ', '.join(missing))
}
do_check_vars[vardeps] = "DIR CMD USER FILENAME"

do_configure:append () {
    sed -e "s,@WORKING_DIR@,${DIR},g" -e "s,@COMMAND_LINE@,${CMD},g" -e "s,@USER@,${USER},g" -e "s,@FILENAME@,${FILENAME},g" < ${WORKDIR}/template.sysvinit > ${B}/template.sysvinit
}
do_configure[vardeps] = "DIR CMD USER FILENAME"
addtask do_check_vars before do_configure

do_install:append () {
    if ${@bb.utils.contains("DISTRO_FEATURES", "sysvinit", "true", "false", d)}; then
        install -d ${D}${INIT_D_DIR}
        install -m 755 ${B}/template.sysvinit ${D}${INIT_D_DIR}/${FILENAME}
    fi
}
do_install[vardeps] = "FILENAME"

FILES:${PN} += "${INIT_D_DIR}/${FILENAME}"
