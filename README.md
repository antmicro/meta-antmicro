# `meta-antmicro` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## `meta-antmicro` sublayers

`meta-antmicro` Yocto layer consists of the following sublayers:

* `meta-antmicro-common` - contains system settings and recipes that are target-independent and used in our demonstration systems introduced in [system-releases directory](system-releases).
* `meta-jetson` - contains settings and recipes specific to Jetson platforms, such as Jetson Nano, Jetson AGX Xavier, or Jetson NX Xavier.
   It also adds CUDA capabilities to the existing software and libraries in the system that support GPU computing.
* `meta-ml` - contains libraries and software used for machine learning, deep learning and computer vision.
* `meta-microros` - contains packages required for adding micro-ROS support for the ROS 2 core image. 

## Yocto BSP build dependencies

All build dependencies for this project are included in a dedicated [Dockerfile](Dockerfile).
To build a development container image, install [Docker](https://www.docker.com/) and run:

```
sudo docker build -t yoctobuilder .
```

This will create a Docker image that can be later used to create the BSP image.

## `meta-antmicro` sample use case

The [system-releases directory](system-releases) provides the Yocto build configuration files, as well as the [Google repo tool](https://gerrit.googlesource.com/git-repo/) to quickly start testing and development of Yocto-based systems.

For example, to build the system that will run the [darknet-imgui-visualization demo with camera feed](https://github.com/antmicro/darknet-imgui-visualization) for one of the Jetson platforms:

* Create the Docker container, which will build the system image in the `<build-dir>` directory that needs to be specified by the user:
  ```
  docker run --rm -v <build-dir>:/data -u $(id -u):$(id -u) -it yoctobuilder
  ```
  *Note: This command runs Docker container that will be removed upon closing (`--rm`), mount the build directory in the `/data` partition in the container (`-v <build-dir>:/data`) and build the system as the `oe-builder` user (`$(id -u):$(id -u)`), since Yocto does not allow `root` builds.*
* Configure git settings and fetch the sources using the `repo` tool present in the Docker container (optionally, you can fetch the sources from your system to avoid git configuration):
  ```
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
  cd /data
  repo init -u https://github.com/antmicro/meta-antmicro.git -m system-releases/darknet-edgeai-demo/manifest.xml
  repo sync -j`nproc`
  ```
* Initialize the build environment:
  ```
  source sources/poky/oe-init-build-env
  ```
* Build the system for one of the Jetson targets, e.g. `jetson-agx-xavier-devkit`:
  ```
  PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="jetson-agx-xavier-devkit" bitbake darknet-edgeai-demo
  ```
  (other available targets are listed in [meta-tegra/conf/machine directory](https://github.com/OE4T/meta-tegra/tree/hardknott/conf/machine)).
* After a successful build, go to the `build/tmp/deploy/images/jetson-agx-xavier-devkit` directory and untar the built tegraflash package:
  ```
  cd build/tmp/deploy/images/jetson-agx-xavier-devkit
  mkdir flash-directory
  cd flash-directory
  tar xzvf ../darknet-edgeai-demo-jetson-agx-xavier-devkit.tegraflash.tar.gz
  ```
* Put the device in recovery mode.
* Make sure that device is available for flashing - run `lsusb | grep -i nvidia` and check if any line appears.
  There should be something like:
  ```
  Bus 001 Device 006: ID 0955:7f21 NVIDIA Corp. APX
  ```  
* Flash the device:
  ```
  sudo ./doflash.sh
  ```
* After the device is successfully flashed, and a camera and screen are connected, you should see the object detection preview.
