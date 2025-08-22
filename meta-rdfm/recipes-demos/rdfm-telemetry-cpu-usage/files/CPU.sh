#!/bin/sh
# Display one report of global statistics from the last second
mpstat 1 1 -o JSON | jq -c
