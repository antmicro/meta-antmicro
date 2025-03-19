# `meta-antmicro` Yocto layer

Copyright (c) 2021-2025 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## `meta-antmicro` sublayers

The `meta-antmicro` Yocto layer consists of the following sublayers:

* [meta-antmicro-common](meta-antmicro-common)
* [meta-jetson-alvium](meta-jetson-alvium)
* [meta-jetson](meta-jetson)
* [meta-microros](meta-microros)
* [meta-ml-tegra](meta-ml-tegra)
* [meta-ml](meta-ml)
* [meta-rdfm-tegra](meta-rdfm-tegra)
* [meta-rdfm](meta-rdfm)
* [meta-antmicro-demo-base](meta-antmicro-demo-base)

## Yocto BSP build dependencies

All build dependencies for this project are included in a dedicated [Dockerfile](Dockerfile).
To build a development container image, install [Docker](https://www.docker.com/) and run:

```
sudo docker build -t yoctobuilder .
```

This will create a Docker image that can be later used to create the BSP image.

## Demos

The [demos directory](demos) provides the Yocto build configuration files, as well as the [Google repo tool](https://gerrit.googlesource.com/git-repo/) manifests to quickly start testing and development of Yocto-based systems.

The following demos are available:
* [Darknet edge AI demo](demos/darknet-edgeai-demo)
* [micro-ROS demo](demos/micro-ros-login-demo)
* [micro-ROS demo (nologin)](demos/micro-ros-nologin-demo)
* [NVIDIA Jetson Orin Baseboard demo](demos/nvidia-jetson-orin-baseboard-demo)
* [HiFive Unmatched RDFM demo](demos/rdfm-unmatched-demo)

Refer to the README files in the demo directories for building and running instructions of each demo.
