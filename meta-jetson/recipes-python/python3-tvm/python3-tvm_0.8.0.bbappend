inherit cuda

STAGING_LOCALDIR = "${WORKDIR}/recipe-sysroot/usr/local"

EXTRA_OECMAKE += " \
    -DUSE_CUDA=${STAGING_LOCALDIR}/cuda-${CUDA_VERSION}/ \
    -DUSE_CUBLAS=ON \
    -DUSE_CUDNN=ON \
    -DUSE_GRAPH_EXECUTOR_CUDA_GRAPH=ON \
    -DCUDA_CUDA_LIBRARY=${STAGING_LOCALDIR}/cuda-${CUDA_VERSION}/stubs/libcuda.so \
    -DCUDA_CUDNN_LIBRARY=${STAGING_LIBDIR}/libcudnn.so \
    -DCUDA_CUDART_LIBRARY=${STAGING_LOCALDIR}/cuda-${CUDA_VERSION}/lib/libcudart.so \
    -DCUDA_CUBLAS_LIBRARY=${STAGING_LIBDIR}/libcublas.so \
    -DCUDA_NVRTC_LIBRARY=${STAGING_LOCALDIR}/cuda-${CUDA_VERSION}/lib/libnvrtc.so \
    -DCUDA_CUDA_INCLUDE_DIRS=${STAGING_LOCALDIR}/cuda-${CUDA_VERSION}/include/ \
    -DCUDA_CUDNN_INCLUDE_DIRS=${STAGING_INCDIR} \
    -DCUDA_TOOLKIT_ROOT_DIR=${STAGING_LOCALDIR}/cuda-${CUDA_VERSION}/ \
    -DUSE_TENSORRT_RUNTIME=ON \
"

DEPENDS += " \
    cudnn \
    cuda-nvrtc \
    tensorrt \
"

RDEPENDS_${PN} += " \
    cudnn \
    cuda-nvrtc \
    tensorrt \
"
