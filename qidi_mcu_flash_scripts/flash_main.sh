#!/bin/bash

# Request bootloader
python3 ~/katapult/scripts/flashtool.py -d /dev/serial/by-id/usb-Klipper_stm32f407xx_BE2F32373534350E35353635-if00 -r

# Flash firmware
python3 ~/katapult/scripts/flashtool.py -d /dev/serial/by-id/usb-katapult_stm32f407xx_BE2F32373534350E35353635-if00 -f ~/klipper/out/klipper.bin
