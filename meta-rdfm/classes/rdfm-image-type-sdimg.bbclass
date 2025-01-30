# Create a flashable SD card image using a .wks.in script.

IMAGE_CMD:sdimg() {
    if [ ! -f "${IMGDEPLOYDIR}/${IMAGE_NAME}.wic" ]; then
        bbfatal ".wic flash file was not generated!"
    fi

    # The flashable images themselves will be created by WIC using a .wks.in script.
    # This image class simply creates a nicer symlink to make it easier to recognize
    ln -sfn "${IMAGE_NAME}.wic" "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.flash_sdimg"
}

IMAGE_TYPEDEP:sdimg:append = " wic "
