# `meta-rdfm-tegra` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-rdfm-tegra` Yocto layer contains settings and recipes to support the [meta-rdfm](../meta-rdfm) layer on Jetson family devices.

## Layer dependencies

The `meta-rdfm-tegra` layer depends on following layers:
* `meta-tegra`
* `meta-rdfm`
* [meta-mender-tegra](https://github.com/mendersoftware/meta-mender-community/)

We recommend to use the `c67c0533418d9ac04ffdc437e7d47022ee26a30b` revision of `meta-mender-tegra` to ensure compatibility between meta-layers.
