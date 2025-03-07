# `Jetson Orin Baseboard` BSP demo

Copyright (c) 2022-2024 [Antmicro](https://www.antmicro.com)

This `nvidia-jetson-orin-baseboard-demo` release lets you build a Board Support Package demo you can run on [the open hardware Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard).

## Quick guide

You can fetch all necessary code with:

<!-- name="fetch-repo"; transformer="echo "$TUTTEST_INPUT" | sed "/repo init/s/.*/& -b $CI_COMMIT_REF_NAME/" | sed "$ a repo forall meta-antmicro -c 'git checkout $CI_COMMIT_REF_NAME'"" -->
```
mkdir orin-baseboard-demo && cd orin-baseboard-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m system-releases/nvidia-jetson-orin-baseboard-demo/manifest.xml
repo sync -j`nproc`
```

To start building the BSP, run the following commands:

<!-- name="build-bsp" -->
```
source sources/poky/oe-init-build-env
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="p3509-a02-p3767-0000" bitbake nvidia-jetson-orin-baseboard-demo
```

When the build process is complete, the resulting image will be stored at `build/tmp/deploy/images/p3509-a02-p3767-0000`.

You can install packages required to flash the board by running:

```
sudo apt-get update
sudo apt-get install gdisk udisks2 bmap-tools
```

Connect the NVMEe storage or USB drive (at least 16 GB, USB3.0) to the device and put the device into recovery mode:
* connect the Recovery USB-C port to your host PC
* press the POWER button (if the device isn't powered yet)
* press and hold the RECOV button
* press the  RESET button
* release the RESET and RECOV buttons
* check if the following USB device is present on your host PC:

```
$lsusb
ID 0955:7323 NVIDIA Corp. APX
```

Then unpack the tegraflash package:

```
cd tmp/deploy/images/p3509-a02-p3767-0000
mkdir flash-directory && cd flash-directory
tar xzvf ../nvidia-jetson-orin-baseboard-demo-p3509-a02-p3767-0000.tegraflash.tar.gz
```

Run the flashing script:

```
sudo ./initrd-flash
```

By default, the NVMEe storage (/dev/nvme0n1p1) will be used to store the rootfs, which you can easily verify by looking at the flash script logs:

```
$ sudo ./initrd-flash
Starting at 2023-05-26T15:35:22+02:00
Machine:       p3509-a02-p3767-0000
Rootfs device: nvme0n1p1
```

If you want to use a USB drive instead of NVMe, you should modify the `TNSPEC_BOOTDEV` variable in the `layer.conf` file in the `meta-jetson-orin-baseboard` sources as follows:

```
TNSPEC_BOOTDEV = "sda1"
```

Now you can rebuild the image and flash again as described above. For a USB drive, the output logs will look like this:

```
Machine:       p3509-a02-p3767-0000
Rootfs device: sda1
```

When flashed successfully, the board should boot up and you will be able to capture a frame from each camera, for example:

```
v4l2-ctl -d0 --stream-mmap --stream-count=1 --stream-to=cam0_image.raw
v4l2-ctl -d1 --stream-mmap --stream-count=1 --stream-to=cam1_image.raw
```

### Configuration
Depending on your camera setup, you can specify a device tree to be used:
```
export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS KERNEL_DEVICETREE"
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="p3509-a02-p3767-0000" KERNEL_DEVICETREE=<specify device tree> bitbake nvidia-jetson-orin-baseboard-demo
```
Examine the table below for supported setups:

| setup                                                     | device tree                                         |
|-----------------------------------------------------------|-----------------------------------------------------|
| 4xOV5640 cameras                                          | tegra234-p3767-0000-antmicro-job.dtb (default)      |
| 4xOV9281 cameras                                          | tegra234-p3767-0000-antmicro-job-ov9281.dtb         |
| GMSL Deserializer + GMSL Serializer + 2xOV5640 camera     | tegra234-p3767-0003-antmicro-job-gmsl-ov5640.dtb    |

Example:
```
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="p3509-a02-p3767-0000" KERNEL_DEVICETREE="tegra234-p3767-0000-antmicro-job-ov9281.dtb" bitbake nvidia-jetson-orin-baseboard-demo
```

### GMSL demo

Steps to setup hardware:
1. connect GMSL Deserializer to Jetson Orin Baseboard on CSI A
2. connect GMSL Serializer #1 to GMSL Deserializer on Channel A
3. connect GMSL Serializer #2 to GMSL Deserializer on Channel B
4. connect GMSL Serializer #1 to the dual camera adapter
5. connect GMSL Serializer #2 to the dual camera adapter
6. connect OV5640 Dual Camera Board to the dual camera adapter
7. plug in the power supply to the GMSL Deserializer
8. power on the jetson orin baseboard

Choose the GMSL device tree & build:
```
export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS KERNEL_DEVICETREE"
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="p3509-a02-p3767-0000" KERNEL_DEVICETREE="tegra234-p3767-0003-antmicro-job-gmsl-ov5640.dtb" bitbake nvidia-jetson-orin-baseboard-demo
```
Flash the board and boot it up. Setup the formats using
```
media-ctl -d /dev/media0 --set-v4l2 '"ser_0_ch_0":1[fmt:YUYV8_1X16/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"des_ch_0":0[fmt:YUYV8_1X16/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"ser_1_ch_0":1[fmt:YUYV8_1X16/1920x1080]'
media-ctl -d /dev/media0 --set-v4l2 '"des_ch_1":0[fmt:YUYV8_1X16/1920x1080]'
```
Capture the feed from cameras using
```
v4l2-ctl --stream-mmap --stream-count=<number_of_frames> -d /dev/video0 --stream-to=gmsl_image_cam1.raw
v4l2-ctl --stream-mmap --stream-count=<number_of_frames> -d /dev/video1 --stream-to=gmsl_image_cam2.raw
```
or observe simultaneous feed from both cameras (external display required)
```
gst-launch-1.0 \
v4l2src device=/dev/video1 ! \
compositor name=mix sink_0::xpos=0 sink_0::ypos=0 sink_1::xpos=1280 sink_1::ypos=0 ! \
videoconvert ! autovideosink \
v4l2src device=/dev/video0 ! \
mix.
```

See more detailed instructions for this demo [here](https://antmicro.github.io/jetson-orin-baseboard/gmsl.html)
