# `meta-jetson-orin-baseboard` Yocto layer

Copyright (c) 2022-2024 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-jetson-orin-baseboard` Yocto layer contains settings and kernel to support [Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard) and four OV5640 cameras on two Antmicro [OV5640 Dual Camera boards](https://github.com/antmicro/ov5640-dual-camera-board).

The kernel used by this layer is based on [OE4T Linux Tegra 5.10](https://github.com/OE4T/linux-tegra-5.10) from branch `oe4t-patches-l4t-r35.2.1`.
It is provided in single-repo form and is [available on GitHub](https://github.com/antmicro/antmicro-jetson-orin-baseboard-kernel-5-10).

## Layer dependencies

The `meta-jetson-orin-baseboard` layer depends on the `meta-jetson` layer.
