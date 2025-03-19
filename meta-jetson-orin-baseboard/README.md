# `meta-jetson-orin-baseboard` Yocto layer

Copyright (c) 2022-2025 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-jetson-orin-baseboard` Yocto layer contains settings and kernel to support [Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard). It also supports several variants of setups with multiple cameras:

* Four OV5640 cameras on two [Antmicro OV5640 Dual Camera boards](https://github.com/antmicro/ov5640-dual-camera-board),
* [GMSL Serializer (MAX96717)](https://github.com/antmicro/gmsl-serializer) and [Deserializer (MAX96724)](https://github.com/antmicro/gmsl-deserializer) with two OV5640 cameras on the [Antmicro OV5640 Dual Camera board](https://github.com/antmicro/ov5640-dual-camera-board) connected via the [Dual Camera to GMSL Serializer CSI Adapter](https://github.com/antmicro/dual-gmsl-serializer-adapter)

There are demos available for each of the configurations. Refer to the [Demos](../README.md#demos) section for more information.

The kernel used by this layer is based on [OE4T Linux Tegra 5.10](https://github.com/OE4T/linux-tegra-5.10) from branch `oe4t-patches-l4t-r35.2.1`.
It is provided in single-repo form and is [available on GitHub](https://github.com/antmicro/antmicro-jetson-orin-baseboard-kernel-5-10).

## Layer dependencies

The `meta-jetson-orin-baseboard` layer depends on the `meta-jetson` layer.
