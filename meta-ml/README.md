# `meta-ml` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-ml` Yocto layer contains recipes for libraries and software used for machine learning, deep learning and computer vision.

The [meta-ml-tegra](../meta-ml-tegra) sublayer extends `meta-ml` functionality for CUDA devices.
Consider including it in your `bblayers.conf` if you are working with the Jetson family of devices.

## Layer dependencies

The `meta-ml` layer depends on the `meta-antmicro-common` layer.

## Images

The `meta-ml` layer adds a recipe for building an image containing `Kenning` and `Apache-TVM`, called `kenning-tvm-image`. It can be extended with CUDA support by the [meta-ml-tegra](../meta-ml-tegra) sublayer.
