inherit cuda

DEPENDS += " \
    cuda-cudart \
    cudnn \
    tegra-libraries \
"

RDEPENDS_${PN} += " \
    cuda-cudart \
    cudnn \
    tegra-libraries \
"
