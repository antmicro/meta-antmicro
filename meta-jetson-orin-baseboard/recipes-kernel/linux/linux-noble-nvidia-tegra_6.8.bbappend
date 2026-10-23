FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_REPO = "github.com/antmicro/antmicro-jetson-orin-baseboard-kernel.git;protocol=https"
KBRANCH = "antmicro-r39.2.1"
SRCREV = "a18dc5e46241678714031272c36bcf23787a435e"

SRC_URI:append = " \
    file://antmicro-job.cfg \
"
