#!/bin/bash

# Request bootloader
python3 katapult/scripts/flashtool.py -b 500000 -d /dev/ttyS4 -r
# Flash klipper
python3 katapult/scripts/flashtool.py -b 500000 -d /dev/ttyS4 -f ~/klipper/out/klipper.bin
