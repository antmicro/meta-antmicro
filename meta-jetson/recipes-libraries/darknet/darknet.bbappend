inherit cuda

DEPENDS += " \
    cuda-cudart \
    cudnn \
    tegra-libraries-cuda \
"

RDEPENDS_${PN} += " \
    cuda-cudart \
    cudnn \
    tegra-libraries-cuda \
"
