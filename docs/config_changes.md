# Qidi Q2 Config Changes (Stock Qidi -> Mainline)

This page lists full target sections to use when moving from stock Qidi config to mainline Klipper on Q2.

Use each full section block as the reference state, then adapt only machine-specific values (MCU serial IDs, tuned values).

## 1) `printer.cfg` sections

### 1.1 Mainboard MCU section

```ini
[mcu]
serial: /dev/serial/by-id/usb-Klipper_stm32f407xx_<your_id>-if00 # Note, replace this with the actual path for your mainboard mcu
restart_method: command
```

Changes:
- Adds explicit mainboard `[mcu]` section in `printer.cfg`.

Why:
- Mainline Klipper setup should not depend on vendor include files for the primary MCU definition.
- Run `ls /dev/serial/by-id/` to get the name of your mcu device.

### 1.2 Toolhead MCU section

```ini
[mcu THR]
serial: /dev/ttyS4
restart_method: command
baud: 500000
```

Changes:
- None, we keep UART toolhead MCU path and baud in the mainline config.

Why:
- Q2 toolhead communication is UART (`/dev/ttyS4`) and must use `500000` baud.

### 1.3 Z steppers (mainline load-cell homing path)

```ini
[stepper_z]
step_pin:PC10
dir_pin:PA15
enable_pin:!PC11
microsteps: 128
rotation_distance: 4
full_steps_per_rotation: 200
endstop_pin: PC3
position_endstop: -2
position_max: 265
position_min: -2
homing_speed: 10
second_homing_speed: 5
homing_retract_dist: 10.0
homing_positive_dir: false

[stepper_z1]
step_pin:PB1
dir_pin:PB6
enable_pin:!PB0
microsteps: 128
rotation_distance: 4
full_steps_per_rotation: 200
```

Changes:
- Removes stock reverse-homing settings (`*_reverse` keys).
- Uses direct Z endstop pin with a mainline-compatible Z model.

Why:
- Mainline klipper does not contain Qidi reverse-homing logic.
- Klipper's implementation of load_cell_probe requires defining an endstop pin, but it isn't used.

### 1.4 X/Y TMC2240 driver sections

```ini
[tmc2240 stepper_x]
spi_software_sclk_pin:PA5
spi_software_miso_pin:PA6
spi_software_mosi_pin:PA7
spi_speed:200000
cs_pin:PC12
diag0_pin:!PB8
interpolate:true
run_current: 1.07
stealthchop_threshold:0
driver_SGT:1
driver_SLOPE_CONTROL:2

[tmc2240 stepper_y]
spi_software_sclk_pin:PA5
spi_software_miso_pin:PA6
spi_software_mosi_pin:PA7
spi_speed:200000
cs_pin:PD2
diag0_pin:!PC0
interpolate:true
run_current: 1.07
stealthchop_threshold:0
driver_SGT:1
driver_SLOPE_CONTROL:2
```

Changes:
- Enables `driver_SLOPE_CONTROL:2` on both X and Y.

Why:
- This reduces stepper heat on Q2 compared to stock commented-out values.

### 1.5 Extruder section (MAX6675 software SPI)

```ini
[extruder]
step_pin:THR:PB9
dir_pin:!THR:PB8
enable_pin:!THR:PC15
rotation_distance: 53.7
gear_ratio: 1517:170
microsteps: 16
full_steps_per_rotation: 200
nozzle_diameter: 0.400
filament_diameter: 1.75
min_temp: 0
max_temp: 375
min_extrude_temp: 170
smooth_time: 0.000001
heater_pin:THR:PB15
sensor_type:MAX6675
sensor_pin:THR:PB12
spi_speed: 100000
spi_software_sclk_pin:THR:PB13
spi_software_miso_pin:THR:PB14
spi_software_mosi_pin:THR:PA15
# spi_bus: spi2
max_power: 1
pressure_advance: 0.032
pressure_advance_smooth_time: 0.03
max_extrude_cross_section:500
instantaneous_corner_velocity: 10.000
max_extrude_only_distance: 1000.0
max_extrude_only_velocity:5000
max_extrude_only_accel:5000
```

Changes:
- Enable software SPI pins for MAX6675.
- Disabled `spi_bus: spi2`.

Why:
- Required for stock toolhead board to boot with mainline klipper.

### 1.6 Chamber heater section

```ini
[heater_generic chamber]
heater_pin:PC8
max_power:1.0
sensor_type:NTC 100K MGB18-104F39050L32
sensor_pin:PA1
control = pid
pid_Kp=63.418
pid_Ki=1.342
pid_Kd=749.125
min_temp:-100
max_temp:70
# z_max_limit:230
```

Changes:
- Comments out `z_max_limit`.

Why:
- Mainline klipper does not have `z_max_limit` as a parameter in this section. Make note of that for your personal use and adjust accordingly.

### 1.7 Load-cell probe section (replaces stock `probe_air`)

```ini
[load_cell_probe]
sensor_type: cs1237
sclk_pin: THR:PB3
dout_pin: THR:PB4
sample_rate: 1280
gain: 128
z_offset: 0
speed: 5
lift_speed: 5
samples: 2
sample_retract_dist: 3
samples_result: average
samples_tolerance: 0.02
samples_tolerance_retries: 10
# Force threshold in grams that counts as a tap.
# 75g is conservative for a direct-drive setup; lower if probe misses taps.
trigger_force: 75
# Uncomment and fill in after running LOAD_CELL_CALIBRATE:
#counts_per_gram: ...
#reference_tare_counts: ...
```

Changes:
- Replaces stock `probe_air` block with mainline `load_cell_probe` using `cs1237`.

Why:
- The CS1237 patch integrates into Klipper's mainline load-cell probe stack.

## 2) `gcode_macro.cfg` sections

### 2.1 Z load-cell homing macros

```ini
[gcode_macro _HOME_Z_FROM_LAST_PROBE]
gcode:
    {% set z_probed = printer.probe.last_probe_position.z %}
    {% set z_position = printer.toolhead.position[2] %}
    {% set z_actual = z_position - z_probed %}
    SET_KINEMATIC_POSITION Z={z_actual}

[gcode_macro _HOME_Z]
gcode:
    SET_GCODE_OFFSET Z=0
    SET_KINEMATIC_POSITION Z={printer.toolhead.axis_maximum[2]}

    PROBE
    _HOME_Z_FROM_LAST_PROBE

    G91
    G1 Z2 F300

    PROBE
    _HOME_Z_FROM_LAST_PROBE

    G91
    G1 Z10 F600
```

Changes:
- Adds dedicated load-cell homing logic for Z with two-probe solve.

Why:
- Replaces stock reverse-homing/G28-Z assumptions with mainline probe-based Z solve.

### 2.2 Homing override

```ini
[homing_override]
axes: xy
gcode:
    M204 S10000
    M220 S100
    SET_STEPPER_ENABLE STEPPER=extruder enable=0

    {% if 'X' in params and 'Y' not in params %}
        _HOME_X
    {% endif %}

    {% if 'Y' in params and 'X' not in params %}
        _HOME_Y
    {% endif %}

    {% if 'X' in params and 'Y' in params %}
        _HOME_XY
    {% endif %}

    {% if 'X' not in params and 'Y' not in params %}
        SET_KINEMATIC_POSITION X=100
        SET_KINEMATIC_POSITION Y=100
        SET_KINEMATIC_POSITION Z={printer.toolhead.axis_maximum.z / 2}
        G91
        G1 Z5 F600
        G4 P500
        _HOME_XY
        G90
        G1 X{printer['gcode_macro PRINTER_PARAM'].max_x_position / 2} Y{printer['gcode_macro PRINTER_PARAM'].max_y_position / 2} F7800
        M400
        _HOME_Z
    {% endif %}

    M204 S10000
    G90
```

Changes:
- Routes full-home path through `_HOME_Z` instead of direct `G28 Z` stock flow.

Why:
- Ensures Z homing follows the mainline load-cell method.

### 2.3 Print start and end macros (mainline-safe)

```ini
[gcode_macro PRINT_START]
gcode:
    DISABLE_ALL_SENSOR
    CLEAR_PAUSE

    {% set bedtemp = params.get('BED')|int %}
    {% set hotendtemp = params.get('HOTEND')|int %}
    {% set chambertemp = params.get('CHAMBER', 0)|int %}

    M104 S0
    M140 S{bedtemp}
    M141 S{chambertemp}
    G28
    SET_GCODE_OFFSET Z=0 MOVE=0

    {% if bedtemp != 0 %}
      TEMPERATURE_WAIT SENSOR=heater_bed MINIMUM={bedtemp * 0.95} MAXIMUM={bedtemp * 1.05}
    {% endif %}

    # Ensure that nozzle is properly heated up for probing
    M109 S140
    M400

    # Move nozzle to center of bed for tap
    G90
    G1 X135 Y135 F7800
    # Tap and home z via PROBE command
    PROBE
    # Adjust for z tilt
    Z_TILT_ADJUST

    # Calibrate an adaptive bed mesh with klippers built-in adaptive meshing
    BED_MESH_CALIBRATE PROFILE=adaptive ADAPTIVE=1

    # Move to corner and wait for hotend to heat up to print temp before printing
    G0 Z30 F600
    G0 X260 Y5 F6000
    M109 S{hotendtemp}
    M204 S10000

    # Set z offset (usually saved in saved_variables.cfg), it is 0.04mm in my case.
    set_zoffset
    # Enable filament sensor and start print
    ENABLE_ALL_SENSOR

[gcode_macro PRINT_END]
gcode:
    M400
    DISABLE_ALL_SENSOR

    {% if 'x' in printer.toolhead.homed_axes and 'y' in printer.toolhead.homed_axes and 'z' in printer.toolhead.homed_axes %}
        G91
        G1 E-3 F1800
        G1 Z3 F600
        G90
        G0 X{printer['gcode_macro PRINTER_PARAM'].clear_x_position} Y{printer['gcode_macro PRINTER_PARAM'].clear_y_position} F12000
        _Z_CLEARANCE DISTANCE=50
    {% endif %}

    M104 S0
    M140 S0
    M141 S0
    M106 P2 S0
    M106 P0 S0
    M106 P3 S0

    save_zoffset
    SET_IDLE_TIMEOUT TIMEOUT={printer.configfile.settings.idle_timeout.timeout}
    CLEAR_PAUSE
    M220 S100
    M221 S100
    BED_MESH_CLEAR
    M84

```

Changes:
- Removes vendor-only calls and dependencies (`BUFFER_MONITORING`, `DISABLE_BOX_HEATER`, `G31`, `CLEAR_LAST_FILE`, `box_extras`).
- Keeps core start/end/cancel behavior needed for normal printing.

Why:
- Prevents runtime errors on mainline configs without Qidi proprietary macro ecosystem.

## 3) Notes

- Full minimal reference sections are also available in:
  - `config_changes/printer.cfg`
  - `config_changes/gcode_macro.cfg`
- Load-cell commissioning workflow is documented in `docs/LOAD_CELL_CALIBRATION.md`.
