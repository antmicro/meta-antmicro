# `meta-rdfm-tegra` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-rdfm-tegra` Yocto layer contains settings and recipes to support the [meta-rdfm](../meta-rdfm) layer on the Jetson family of devices.

## Layer dependencies

The `meta-rdfm-tegra` layer depends on the following layers:
* `meta-tegra`
* `meta-rdfm`
* [meta-mender-tegra](https://github.com/mendersoftware/meta-mender-community/)

We recommend using the `7557075f4751c8394f72720056e0e766191610a5` revision of `meta-mender-tegra` to ensure compatibility between meta-layers.
