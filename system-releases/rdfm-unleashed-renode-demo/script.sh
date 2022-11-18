#!/bin/bash

PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="freedom-u540" bitbake rdfm-image-minimal $@
PARALLEL_MAKE="-j $(nproc)" BB_NUMBER_THREADS="$(nproc)" MACHINE="freedom-u540" bitbake rdfm-image-upgraded $@
