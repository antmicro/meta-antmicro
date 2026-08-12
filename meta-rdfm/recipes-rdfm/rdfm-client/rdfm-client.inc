# Based on https://github.com/mendersoftware/meta-mender/blob/7221ae1a7e12bf8416cca630a829336c0d45faf6/meta-mender-core/recipes-mender/mender-client/mender-client.inc

DESCRIPTION = "Rdfm tool for doing OTA software updates."
HOMEPAGE = "https://github.com/antmicro/rdfm"

BBCLASSEXTEND = "native"
RDEPENDS:${PN}:class-native = ""
DEPENDS:class-native = ""

RDFM_UPDATE_POLL_INTERVAL_SECONDS ?= "1800"
RDFM_INVENTORY_POLL_INTERVAL_SECONDS ?= "28800"
RDFM_RETRY_POLL_INTERVAL_SECONDS ?= "300"

RDFM_SHELL_PATH ?= "/bin/login"

# Override the default helper used for fetching the bootloader environment
RDFM_BOOT_UTILS_GETENV_OVERRIDE ?= ""
# Override the default helper used for setting the bootloader environment
RDFM_BOOT_UTILS_SETENV_OVERRIDE ?= ""

RDFM_SERVER_CERTIFICATE_BSP_PATH ?= ""

inherit go pkgconfig systemd

FILES:${PN} += "\
    ${sysconfdir}/udev/mount.blacklist.d/rdfm \
    /data/rdfm/device_type \
    /data/rdfm/rdfm.conf \
"

SYSROOT_DIRS += "/data"

# Go binaries produce unexpected effects that the Yocto QA mechanism doesn't
# like. We disable those checks here.
INSANE_SKIP:${PN} = "ldflags textrel"

PACKAGECONFIG ?= ""

# The docker module depends on bash, and of course on docker. However, docker is
# a very large requirement, which we will not mandate. Bash however, we require,
# because otherwise the Yocto QA checks will complain.
PACKAGECONFIG[modules] = ",,,bash"
PACKAGECONFIG[dbus] = ",,glib-2.0,glib-2.0"
PACKAGECONFIG[inventory-network-scripts] = ",,,"

# NOTE: Splits the mender.conf file by default into a transient and a persistent config. Needs to be
# explicitly disabled if this is not to apply.
PACKAGECONFIG[split-mender-config] = ",,,"
PACKAGECONFIG:append = " split-mender-config"

_RDFM_TAGS = "${@bb.utils.contains('PACKAGECONFIG', 'dbus', '', 'nodbus', d)}"
EXTRA_OEMAKE:append = " TAGS='${_RDFM_TAGS}'"
# Changes to tags are not automatically picked up by the Makefile, so repopulate
# the build directory from scratch if changing this.
do_unpack[vardeps] += "_RDFM_TAGS"

do_configure:prepend () {
    # Remove all the src present in build if it is not a symbolic link to ${S}
    if [ -d ${B}/src ]; then
        rm -rf ${B}/src
    fi
}

do_configure:append () {
    # Remove the symbolic link created by go.bbclass in do_configure. This is to
    # make sure that the build environment ${B} does not touch ${S} in any way.
    if [ -h ${B}/src ]; then
        rm ${B}/src
    fi
    mkdir -p $(dirname ${B}/src/)
    cp --archive ${S} ${B}/src/
}

do_compile() {
    GOPATH="${B}:${S}"
    export GOPATH
    PATH="${B}/bin:$PATH"
    export PATH

    # mender is using vendored dependencies, any 3rd party libraries go to into
    # /vendor directory inside mender source tree. In order for `go build` to pick
    # up vendored deps from our source tree, the mender source tree itself must be
    # located inside $GOPATH/src/
    #
    # recreate temporary $GOPATH/src/ structure and link our source tree
    mkdir -p ${B}/src/
    ln -s ${S} ${B}/src/
    cd ${B}/src/devices/linux-client

    # run verbose build, we should see which dependencies are pulled in
    oe_runmake V=1

    # Workaround for https://github.com/golang/go/issues/35615 causing failures
    # when do_rm_work is executed
    find ${B}/pkg/mod -exec chmod u+w {} \;

    echo "device_type=${RDFM_DEVICE_TYPE}" > ${B}/device_type
}

python do_prepare_mender_conf() {
    import json

    # If a mender.conf has been provided in SRC_URI, merge this with the
    # settings we generate. The settings specified by variables take precedence.
    src_conf = os.path.join(d.getVar("WORKDIR"), "mender.conf")
    if os.path.exists(src_conf):
        bb.debug(1, "mender.conf already present in ${WORKDIR}, merging with generated settings.")
        fd = open(src_conf)
        transient_conf = json.load(fd)
        fd.close()
    else:
        bb.debug(1, "mender.conf not present in ${WORKDIR}, generating a new one.")
        transient_conf = {}
    def conf_maybe_add(key, value, getvar, integer):
        if getvar:
            warn_str = "variable '%s'" % value
            value = d.getVar(value)
        else:
            warn_str = "automatically provided settings"
        if value is not None and value != "":
            if transient_conf.get(key) is not None and transient_conf[key] != value:
                bb.warn("Configuration key '%s', found in mender.conf, conflicts with %s. Choosing the latter." % (key, warn_str))
            if integer:
                transient_conf[key] = int(value)
            else:
                transient_conf[key] = value

    # Add new variable -> config assignments here.
    conf_maybe_add("InventoryPollIntervalSeconds", "RDFM_INVENTORY_POLL_INTERVAL_SECONDS", getvar=True, integer=True)
    if bb.utils.contains("IMAGE_INSTALL", "rdfm-telemetry-config", True, False, d):
        conf_maybe_add("TelemetryEnable", True, getvar=False, integer=False)
        conf_maybe_add("TelemetryBatchSize", "RDFM_TELEMETRY_BATCH_SIZE", getvar=True, integer=True)
        conf_maybe_add("TelemetryLogLevel", "RDFM_TELEMETRY_LOG_LEVEL", getvar=True, integer=False)
        conf_maybe_add("TelemetryBootstrapServers", "RDFM_TELEMETRY_BOOTSTRAP_SERVERS", getvar=True, integer=False)
    # Mandatory variables - will always exist
    conf_maybe_add("RetryPollIntervalSeconds", "RDFM_RETRY_POLL_INTERVAL_SECONDS", getvar=True, integer=True)
    conf_maybe_add("RootfsPartA", "RDFM_PARTITION_ROOTFS_A", getvar=True, integer=False)
    conf_maybe_add("RootfsPartB", "RDFM_PARTITION_ROOTFS_B", getvar=True, integer=False)
    if d.getVar("RDFM_BOOT_UTILS_SETENV_OVERRIDE") != "":
        conf_maybe_add("BootUtilitiesSetActivePart", "RDFM_BOOT_UTILS_SETENV_OVERRIDE", getvar=True, integer=False)
    if d.getVar("RDFM_BOOT_UTILS_GETENV_OVERRIDE") != "":
        conf_maybe_add("BootUtilitiesGetNextActivePart", "RDFM_BOOT_UTILS_GETENV_OVERRIDE", getvar=True, integer=False)
    conf_maybe_add("ServerURL", "RDFM_SERVER_URL", getvar=True, integer=False)
    conf_maybe_add("ServerCertificate", "RDFM_SERVER_CERTIFICATE_BSP_PATH", getvar=True, integer=False)
    conf_maybe_add("UpdatePollIntervalSeconds", "RDFM_UPDATE_POLL_INTERVAL_SECONDS", getvar=True, integer=True)
    conf_maybe_add("ShellPath", "RDFM_SHELL_PATH", getvar=True, integer=False)

    dst_conf = os.path.join(d.getVar("B"), "transient_mender.conf")
    fd = open(dst_conf, "w")
    json.dump(transient_conf, fd, indent=4, sort_keys=True)
    fd.close()

}
addtask do_prepare_mender_conf after do_compile before do_install
do_prepare_mender_conf[vardeps] = " \
    RDFM_INVENTORY_POLL_INTERVAL_SECONDS \
    RDFM_RETRY_POLL_INTERVAL_SECONDS \
    RDFM_PARTITION_ROOTFS_A \
    RDFM_PARTITION_ROOTFS_B \
    RDFM_SERVER_URL \
    RDFM_UPDATE_POLL_INTERVAL_SECONDS \
    RDFM_BOOT_UTILS_SETENV_OVERRIDE \
    RDFM_BOOT_UTILS_GETENV_OVERRIDE \
    RDFM_SERVER_CERTIFICATE_BSP_PATH \
    RDFM_TELEMETRY_BOOTSTRAP_SERVERS \
    RDFM_SHELL_PATH \
"

python do_check_for_required_datastore_variables() {
    this =  "do_" + d.getVar("BB_CURRENTTASK")

    for vardep in d.getVarFlags(this)["vardeps"].split():
        if not d.getVar(vardep):
            bb.fatal(f"Required value {vardep} not present in datastore")
}
addtask do_check_for_required_datastore_variables before do_fetch
do_check_for_required_datastore_variables[vardeps] = " \
    RDFM_SERVER_URL \
"

do_install() {
    oe_runmake \
        -C ${B}/src/devices/linux-client \
        V=1 \
        prefix=${D} \
        bindir=${bindir} \
        datadir=${datadir} \
        sysconfdir=${sysconfdir} \
        install-bin

    #install our prepared configuration
    install -d ${D}/${sysconfdir}/rdfm
    install -d ${D}/data/rdfm
    if [ -f ${B}/transient_mender.conf ]; then
        install -m 0600 ${B}/transient_mender.conf ${D}/${sysconfdir}/rdfm/rdfm.conf
        install -m 0600 ${B}/transient_mender.conf ${D}/data/rdfm/rdfm.conf
    fi

    install -d ${D}/${localstatedir}/lib/rdfm

    # symlink /var/lib/rdfm to /data/rdfm
    rm -rf ${D}/${localstatedir}/lib/rdfm
    ln -s /data/rdfm ${D}/${localstatedir}/lib/rdfm

    install -m 755 -d ${D}/data/rdfm
    install -m 444 ${B}/device_type ${D}/data/rdfm/

    # Setup blacklist to ensure udev does not automatically mount RDFM managed partitions
    install -d ${D}${sysconfdir}/udev/mount.blacklist.d
    echo ${RDFM_PARTITION_ROOTFS_A} > ${D}${sysconfdir}/udev/mount.blacklist.d/rdfm
    echo ${RDFM_PARTITION_ROOTFS_B} >> ${D}${sysconfdir}/udev/mount.blacklist.d/rdfm
}
