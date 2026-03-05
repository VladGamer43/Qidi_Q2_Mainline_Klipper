# Known-Good Matrix

This page captures the pinned fallback revisions and config artifacts used for this guide.

## Pinned fallback commits

If applying to latest upstream fails, use:

- Klipper fallback commit: `88a71c3ce5383085b18d87d76ac42686ec7fad9f`
- Katapult fallback commit: `32584cbbb66c4dc85fc87c0fa87ed508f7c2df52`

## Canonical patch files

- Klipper patch: `patches/klipper/0001-q2-mainboard-usb-and-cs1237.patch`
- Katapult patch: `patches/katapult/0001-q2-mainboard-usb.patch`

## Config artifacts used to build patch files

### Klipper

- Mainboard config artifact: `klipper_patch/.main_mcu.config`
- Toolhead config artifact: `klipper_patch/.th_mcu.config`

Key flags in mainboard artifact:

- `CONFIG_MCU="stm32f407xx"` (GD32F425-compatible target path)
- `CONFIG_STM32F4_GD32_USB_INIT_WORKAROUND=y`
- `CONFIG_WANT_CS1237=y`
- `CONFIG_WANT_TRIGGER_ANALOG=y`

Key flags in toolhead artifact:

- `CONFIG_MCU="stm32f103xe"` (used in current patchset for toolhead target)
- `CONFIG_SERIAL_BAUD=500000`

### Katapult

- Mainboard config artifact: `katapult_patch/.main_mcu.config`
- Toolhead config artifact: `katapult_patch/.th_mcu.config`

Key flags in mainboard artifact:

- `CONFIG_MCU="stm32f407xx"` (GD32F425-compatible target path)
- `CONFIG_STM32F4_GD32_USB_INIT_WORKAROUND=y`
- `CONFIG_STM32_APP_START_8000=y`

Key flags in toolhead artifact:

- `CONFIG_MCU="stm32f103xe"`
- `CONFIG_SERIAL_BAUD=500000`
- `CONFIG_STM32_APP_START_2000=y`
