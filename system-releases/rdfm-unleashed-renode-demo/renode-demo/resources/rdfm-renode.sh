#!/bin/bash

# This script is used to run the OTA update demo in Renode.
# It does the following:
# 1. Adds a tap interface and bridge and connects them, it's needed for Renode to be able to communicate with the computer
# 4. Flushes the global scope for IP addresses and assigns a new IP address to the bridge interface
# 5. Generates a delta update using the deltas.sh script and two specified image files
# 6. Starts an HTTP server to make the files needed for the update accessible
# 7. Runs the Unleashed emulation in Renode with specified options for logging and console output
ip tuntap add tap0 mode tap
ip link add br0 type bridge
ip link set up dev tap0
ip link set up dev br0
ip link set tap0 master br0
ip addr flush scope global
ip addr add 100.64.0.1/10 dev br0
./deltas.sh rdfm-image-minimal-freedom-u540.rdfm rdfm-image-upgraded-freedom-u540.rdfm
python3 -m http.server 12345 &
renode --disable-xwt --console -e 'logLevel 3 console ; logFile @log.txt ; i @rdfm-demo.resc ; s ; uart_connect sysbus.uart0'
