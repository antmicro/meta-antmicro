# `Jetson Orin Baseboard` demo

Copyright (c) 2022-2025 [Antmicro](https://www.antmicro.com)

`nvidia-jetson-orin-baseboard-demo` allows you to build a Board Support Package that you can run on [the open hardware Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard).

## Building the image

You can fetch all necessary code with:

<!-- name="fetch-repo"; transformer="echo "$TUTTEST_INPUT" | sed "/repo init/s/.*/& -b $CI_COMMIT_REF_NAME/" | sed "$ a repo forall meta-antmicro -c 'git checkout $CI_COMMIT_REF_NAME'"" -->
```sh
mkdir orin-baseboard-demo && cd orin-baseboard-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m demos/nvidia-jetson-orin-baseboard-demo/manifest.xml
repo sync -j`nproc`
```

To start building the BSP, run the following commands:

<!-- name="build-bsp" -->
```sh
source sources/poky/oe-init-build-env
bitbake nvidia-jetson-orin-baseboard-demo
```

When the build process is complete, the resulting image will be stored at  `build/tmp/deploy/images/p3509-a02-p3767-0000/nvidia-jetson-orin-baseboard-demo-p3509-a02-p3767-0000.tegraflash.tar.gz`.

## Preparing the hardware setup

To prepare the setup, please follow the steps outlined in the following sections of the [Jetson Orin Baseboard Getting started guide](https://antmicro.github.io/jetson-orin-baseboard/getting_started.html#):
* [Collect the hardware](https://antmicro.github.io/jetson-orin-baseboard/getting_started.html#collect-the-hardware)
* [Build your setup](https://antmicro.github.io/jetson-orin-baseboard/getting_started.html#build-your-setup)

## Flashing the image to the board

To flash the image, please follow the [Flash the BSP image](https://antmicro.github.io/jetson-orin-baseboard/getting_started.html#flash-the-bsp-image) instructions, with one difference: instead of downloading the BSP image file in the "Get the BSP image" step, use the one available at `build/tmp/deploy/images/p3509-a02-p3767-0000/nvidia-jetson-orin-baseboard-demo-p3509-a02-p3767-0000.tegraflash.tar.gz`.
