# `Jetson Orin Baseboard` BSP demo

This `nvidia-jetson-orin-baseboard-demo` release lets you build a Board Support Package demo you can run on [the open hardware Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard).

## Quick guide

You can fetch all necessary code with:

```
mkdir orin-baseboard-demo && cd orin-baseboard-demo
repo init -u https://github.com/antmicro/meta-antmicro.git -m system-releases/nvidia-jetson-orin-baseboard-demo/manifest.xml
repo sync -j`nproc`
```

To start building the BSP, run the following commands:
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