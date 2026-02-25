# Patch Scope

This page summarizes what is changed by the canonical patch files in this repository.

## Canonical patch files

- Klipper: `patches/klipper/0001-q2-mainboard-usb-and-cs1237.patch`
- Katapult: `patches/katapult/0001-q2-mainboard-usb.patch`

These are intended for `git apply` on upstream clones.

## Klipper patch scope

### MCU / USB bring-up (GD32F425 on STM32F4 path)

- `src/stm32/usbotg.c`
- `src/stm32/Kconfig`
- `src/generic/usb_cdc_ep.h`

Purpose:

- Add `CONFIG_STM32F4_GD32_USB_INIT_WORKAROUND`.
- Apply GD32-safe USB core/session init.
- Stabilize enumeration/control handling and bulk OUT re-arming.
- Use endpoint layout and EP0 sizing validated for this target.

### CS1237 load-cell support

- `src/sensor_cs1237.c`
- `src/Kconfig`
- `src/Makefile`
- `klippy/extras/cs1237.py`
- `klippy/extras/load_cell.py`
- `klippy/extras/load_cell_probe.py`

Purpose:

- Add MCU-side CS1237 sensor driver and command surface.
- Register CS1237 as a selectable load-cell / load-cell-probe sensor type.
- Integrate with trigger_analog and bulk sensor flow.

### Fix MCU and host communication timeout errors

- `klippy/mcu.py`

Purpose:

- `TRSYNC_TIMEOUT` changed to 0.050 from 0.025 to fix issues with communication timeout errors.

## Katapult patch scope

- `src/stm32/usbotg.c`
- `src/stm32/Kconfig`
- `src/generic/usb_cdc_ep.h`
- `src/generic/usb_cdc.h`

Purpose:

- Add the same GD32 USB workaround concept in Katapult so USB bootloader behavior is reliable on Q2 mainboard hardware.

## Saved menuconfig artifacts

Raw artifact folders include:

- `.main_mcu.config`
- `.th_mcu.config`

These are used as deterministic build inputs for the documented firmware targets.

## Detailed technical explanations

- [GD32F425_USB_PATCH_EXPLAINED.md](../GD32F425_USB_PATCH_EXPLAINED.md)
- [CS1237_PATCH_EXPLAINED.md](../CS1237_PATCH_EXPLAINED.md)
