# `Jetson Orin Baseboard OV5640` demo

Copyright (c) 2022-2025 [Antmicro](https://www.antmicro.com)

`nvidia-jetson-orin-baseboard-ov5640-demo` allows you to build a Board Support Package that you can run on [the open hardware Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard). It supports four OV5640 cameras on two [Antmicro OV5640 Dual Camera boards](https://github.com/antmicro/ov5640-dual-camera-board).

## Building the image

You can fetch all necessary code with:

<!-- name="fetch-repo"; transformer="echo "$TUTTEST_INPUT" | sed "/repo init/s/.*/& -b $CI_COMMIT_REF_NAME/" | sed "$ a repo forall meta-antmicro -c 'git checkout $CI_COMMIT_REF_NAME'"" -->
```sh
mkdir orin-baseboard-demo && cd orin-baseboard-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m demos/nvidia-jetson-orin-baseboard-ov5640-demo/manifest.xml
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

In addition to that, the following hardware will be needed to complete the demo setup:
* Two [Antmicro OV5640 Dual Camera boards](https://github.com/antmicro/ov5640-dual-camera-board)
* Two 50-pin FFC cables

Connect one of the camera boards to the Jetson Orin Baseboard `CSI A` port and the other to the `CSI B` port using the FFC cables.

## Flashing the image to the board

To flash the image, please follow the [Flash the BSP image](https://antmicro.github.io/jetson-orin-baseboard/getting_started.html#flash-the-bsp-image) instructions, with one difference: instead of downloading the BSP image file in the "Get the BSP image" step, use the one available at `build/tmp/deploy/images/p3509-a02-p3767-0000/nvidia-jetson-orin-baseboard-demo-p3509-a02-p3767-0000.tegraflash.tar.gz`.

## Accessing the cameras

The BSP comes with pre-installed software to test video streaming from the cameras. Use the following commands to capture a frame from each of the cameras:

```sh
v4l2-ctl -d0 --stream-mmap --stream-count=1 --stream-to=cam1_image.raw
v4l2-ctl -d1 --stream-mmap --stream-count=1 --stream-to=cam2_image.raw
v4l2-ctl -d2 --stream-mmap --stream-count=1 --stream-to=cam3_image.raw
v4l2-ctl -d3 --stream-mmap --stream-count=1 --stream-to=cam4_image.raw
```

