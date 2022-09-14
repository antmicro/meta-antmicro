_RDFM_IMAGE_DEPS_EXTRA = ""
_RDFM_IMAGE_DEPS_EXTRA:tegra = "tegra-state-scripts:do_deploy"
do_image_rdfm[depends] += "${_RDFM_IMAGE_DEPS_EXTRA}"
