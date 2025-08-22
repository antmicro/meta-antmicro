SRC_URI = " \
        git://github.com/antmicro/rdfm.git;protocol=https;branch=main;destsuffix=git \
	file://CPU.sh \
        file://stress_script.sh \
        file://rdfm_dev_eth0_config.resc \
        file://demo_broker_certs \
        file://demo_server_certs \
"
SRCREV = "636fcf9ab5a695852b18c2cea2c5f7e0a807b412"

RDEPENDS:${PN}:append = " sysstat jq stress-ng"
DEPENDS += "bash-native openssl-native"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

inherit deploy

do_configure () {
    # Replace docker DNS name with specified host address
    sed -e "s,DEV://broker,DEV://${RDFM_MGMT_HOST_ADDRESS},g" \
        ${S}/server/deploy/pubsub-demo/docker-compose.kafka.yml > ${B}/docker-compose.kafka.yml

    # Remove rdfm-linux-client section
    awk '/^\s+rdfm-linux-client:/{f=1; next} /^[^[:space:]]/{f=0} !f' \
        ${S}/server/deploy/pubsub-demo/docker-compose.rdfm.yml > ${B}/docker-compose.rdfm.yml

    # Helper .resc script for setting up eth0 and proper date suitable for demo certs
    sed -e "s,@DEVICE_HOST@,${RDFM_DEV_HOST_ADDRESS},g" \
        ${WORKDIR}/rdfm_dev_eth0_config.resc > ${B}/rdfm_dev_eth0_config.resc

}
do_configure[vardeps] = "RDFM_MGMT_HOST_ADDRESS"
do_configure[vardeps] = "RDFM_DEV_HOST_ADDRESS"

do_install () {
    install -d ${D}${RDFM_LOGGERS_BINDIR}
    install -m 700 ${WORKDIR}/CPU.sh ${D}${RDFM_LOGGERS_BINDIR}/CPU.sh
    install -m 700 ${WORKDIR}/stress_script.sh ${D}${RDFM_LOGGERS_BINDIR}/stress_script.sh

    install -d ${D}/data/rdfm
    install -m 600 ${WORKDIR}/demo_server_certs/CA.crt ${D}/data/rdfm/CA.crt
}
do_install[vardeps] += "RDFM_LOGGERS_BINDIR"

FILES:${PN} = " \
    ${RDFM_LOGGERS_BINDIR}/stress_script.sh \
    ${RDFM_LOGGERS_BINDIR}/CPU.sh \
    /data/rdfm/CA.crt \
"

do_deploy () {
    cp -r ${S}/server/deploy/pubsub-demo ${DEPLOYDIR}/pubsub-demo
    cp -r ${B}/docker-compose.kafka.yml ${DEPLOYDIR}/pubsub-demo/docker-compose.kafka.yml
    cp -r ${B}/docker-compose.rdfm.yml ${DEPLOYDIR}/pubsub-demo/docker-compose.rdfm.yml
    cp -r ${B}/rdfm_dev_eth0_config.resc ${DEPLOYDIR}/pubsub-demo/rdfm_dev_eth0_config.resc

    # These archives were automatically extracted by bitbake
    cp -r ${WORKDIR}/demo_broker_certs ${DEPLOYDIR}/pubsub-demo/broker
    cp -r ${WORKDIR}/demo_server_certs ${DEPLOYDIR}/pubsub-demo/server
}
addtask deploy after do_install
