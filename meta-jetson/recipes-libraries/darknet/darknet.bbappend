inherit cuda

DEPENDS += " \
    cuda-cudart \
    cudnn \
    tegra-libraries-cuda \
"

RDEPENDS:${PN} += " \
    cuda-cudart \
    cudnn \
    tegra-libraries-cuda \
"
