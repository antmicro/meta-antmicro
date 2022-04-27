inherit cuda

STAGING_LOCALDIR = "${WORKDIR}/recipe-sysroot/usr/local"

EXTRA_OECMAKE += " \
    -DUSE_CUDA=${STAGING_LOCALDIR}/cuda-10.2/ \
    -DUSE_CUBLAS=ON \
    -DUSE_CUDNN=ON \
    -DUSE_GRAPH_EXECUTOR_CUDA_GRAPH=ON \
    -DCUDA_FOUND=TRUE \
    -DCUDA_CUDA_LIBRARY=${STAGING_LOCALDIR}/cuda-10.2/stubs/libcuda.so \
    -DCUDA_CUDNN_LIBRARY=${STAGING_LIBDIR}/libcudnn.so \
    -DCUDA_CUDART_LIBRARY=${STAGING_LOCALDIR}/cuda-10.2/lib/libcudart.so \
    -DCUDA_CUBLAS_LIBRARY=${STAGING_LIBDIR}/libcublas.so \
    -DCUDA_NVRTC_LIBRARY=${STAGING_LOCALDIR}/cuda-10.2/lib/libnvrtc.so \
    -DCUDA_CUDA_INCLUDE_DIRS=${STAGING_LOCALDIR}/cuda-10.2/include/ \
    -DCUDA_CUDNN_INCLUDE_DIRS=${STAGING_INCDIR} \
    -DCUDA_TOOLKIT_ROOT_DIR=${STAGING_LOCALDIR}/cuda-10.2/ \
"

DEPENDS += " \
    cudnn \
    cuda-nvrtc \
"

RDEPENDS_${PN} += " \
    cudnn \
    cuda-nvrtc \
"
