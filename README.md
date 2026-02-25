# Qidi Q2 Mainline Klipper Guide (Stock Hardware)

This repository documents and hosts the patchset required for running mainline Klipper firmware on the stock electronics of the Qidi Q2. The Qidi Q2 uses a GD32F425 as the MCU for its mainboard, it is functionally a clone of the STM32F407. However it is not readily compatible with Klipper as there are some differences between the two that must be accounted for. Additionally the Q2 uses a CS1237 ADC for load cell probing with the nozzle, this is not compatible with Klipper out of the box either.

## What this enables

- Mainboard (`GD32F425`) running mainline Klipper with stable USB CDC enumeration/communication.
- Mainboard Katapult build with the same GD32 USB workaround.
- Toolhead board firmware flow kept in the same repo for reproducible builds.
- `CS1237` load cell support integrated into the mainline Klipper load-cell stack (`load_cell` / `load_cell_probe`).

## Installation Guidelines

- Keep the stock Q2 AP-board OS and update/tune it (external community guide).
- Install latest Klipper stack with KIAUH.
- Clone latest upstream `klipper` and `katapult`.
- Clone this repo and run `./apply_patch.sh`.
- Flash Katapult via ST-Link, then flash Klipper via Katapult.

## Start here

- Full installation and flashing flow: [docs/INSTALL.md](docs/INSTALL.md)
- Required stock->mainline config changes: [docs/config_changes.md](docs/config_changes.md)
- Patch/file scope summary: [docs/PATCH_SCOPE.md](docs/PATCH_SCOPE.md)
- Version matrix and config artifacts: [docs/KNOWN_GOOD_MATRIX.md](docs/KNOWN_GOOD_MATRIX.md)

## Notes

- The flash scripts in `qidi_mcu_flash_scripts/` are intentionally simple examples.
- Device paths (`/dev/serial/by-id/...`, `/dev/ttyS4`) are environment-specific and must be confirmed on your machine.

## DISCLAIMER

I am NOT responsible for anything that happens if you decide to install mainline Klipper onto your Qidi Q2. I will not provide any dedicated support. You do this at your own endeavour. This is merely a resource that I am providing on how I got mainline Klipper running on the stock hardware of the Qidi Q2. Also a little bit of a flex because many others tried before me but could never get the GD32F425 to successfully enumerate via USB nor get the CS1237 to function with Klipper.
