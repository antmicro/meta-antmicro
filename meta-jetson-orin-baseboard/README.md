# `meta-jetson-orin-baseboard` Yocto layer

Copyright (c) 2022-2024 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-jetson-orin-baseboard` Yocto layer contains settings and kernel patches to support [Jetson Orin Baseboard](https://github.com/antmicro/jetson-orin-baseboard) and four OV5640 cameras on two Antmicro [OV5640 Dual Camera boards](https://github.com/antmicro/ov5640-dual-camera-board).
The patches are generated from a custom version of [kernel 5.10](https://github.com/antmicro/antmicro-jetson-orin-baseboard-kernel-5-10).

## Layer dependencies

The `meta-jetson-orin-baseboard` layer depends on the `meta-jetson` layer.
