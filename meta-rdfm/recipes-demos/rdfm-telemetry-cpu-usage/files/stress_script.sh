#!/bin/sh
echo "stressing..."
stress-ng --cpu 2 -t 1m --temp-path /tmp
echo "done stressing!"
