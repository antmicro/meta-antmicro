# `meta-microros` Yocto layer

Copyright (c) 2021-2022 [Antmicro](https://www.antmicro.com)

Antmicro's collection of Yocto layers for machine learning and computer vision applications.

## Description

The `meta-microros` Yocto layer contains recipes for adding `micro-ROS` support for the `ROS 2` core image.

This layer extends the functionality of the [meta-ros2-galactic](https://github.com/ros/meta-ros/tree/master/meta-ros2-galactic) layer.

The [demos directory](../demos) provides micro-ROS demos implementing the [Renode micro-ROS demo](https://github.com/antmicro/renode-microros-demo).

## Layer dependencies

The `meta-microros` layer depends on the following Yocto layers:
* `meta-ros/meta-ros-common`
* `meta-ros/meta-ros2`
* `meta-ros/meta-ros2-galactic`
