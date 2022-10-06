#!/bin/bash

PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="freedom-u540" bitbake core-image-minimal $@
