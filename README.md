# ESP32 WiFi Humidistat

An ESPHome-based whole-house humidifier controller for ESP32 and Home Assistant that targets the highest safe indoor humidity without causing window condensation.

The controller combines indoor temperature, indoor humidity, forecast outdoor low temperature, and a calibrated interior window temperature model to compute a safe humidity target. It then opens the humidifier only during a heat call and only when the measured zone humidity is below the calculated target.

This project is aimed at a very specific gap: users who want a standalone Wi-Fi humidistat for a whole-house humidifier that is also Home Assistant-native, forecast-aware, and smart enough to protect windows from condensation. Conventional humidifier controls and replacement humidistats exist, but this combination of features is difficult to find as a single off-the-shelf product.

## Why This Project Exists

Most whole-house humidifier controls are built around simple fixed setpoints, outdoor temperature knobs, or proprietary ecosystems. They usually do not offer all of the following in one system:

- Home Assistant integration
- Wi-Fi connectivity
- zone-specific control using thermostat data
- weather-aware humidity targeting
- explicit condensation-limit modeling
- manual override with transparent dashboard feedback
- safe relay control that is still constrained by a real furnace heat call

This project treats humidification as a physics and automation problem rather than just a dial on a duct-mounted controller.

Instead of asking:

```text
What humidity setting should I leave it on all winter?
```

it asks:

```text
Given today's indoor conditions, tonight's forecast low, and the likely coldest part of the window,
what is the highest safe RH I can allow right now?
```

## Features

- ESPHome firmware for ESP32
- Home Assistant integration through the ESPHome API
- Forecast-driven humidity control using OpenWeatherMap
- Physics-based condensation limit using the Magnus equation
- Designed for whole-house humidifiers, not just tabletop units
- Adjustable safety margin, ceiling, and deadband
- Manual humidity mode with automatic ceiling enforcement
- Heat-call interlock support for safe whole-house humidifier wiring
- Separate `Zone A` and `Zone B` example device configurations
- Standalone ESPHome YAML files that work well with Home Assistant ESPHome Builder

## Repository Layout

```text
ESP32-Wifi-Humidistat
├── README.md
├── LICENSE
├── CHANGELOG.md
├── .gitignore
├── docs
│   ├── calibration.md
│   ├── dashboard.md
│   ├── theory.md
│   ├── troubleshooting.md
│   ├── tuning.md
│   └── wiring.md
├── esphome
│   ├── zone-a.yaml
│   ├── secrets.example.yaml
│   └── zone-b.yaml
├── images
│   ├── system-overview.svg
│   └── wiring-example.svg
└── tools
    └── esphome-build.sh
```

## How It Works

1. Home Assistant provides the zone's control temperature and control humidity from the thermostat's climate entity.
2. OpenWeatherMap provides the coldest forecasted temperature from the next 24 hours.
3. The firmware estimates the inside surface temperature of the most condensation-prone window area.
4. The Magnus equation computes the maximum humidity that avoids condensation.
5. The controller subtracts a safety margin and applies a ceiling to create the active humidity setpoint.
6. The relay opens the humidifier only when:
   - HVAC mode is `heat`
   - humidity is below the `On` threshold
   - the fail-safe checks still have valid control inputs

## What Makes It Different

This controller is unusual because it combines:

- whole-house humidifier control
- ESPHome and Home Assistant integration
- forecast data
- explicit window-condensation protection
- a transparent, tunable humidity target instead of a fixed winter setting

In practice, that means you can expose the logic directly in Home Assistant, tune it for your actual windows, and understand why the controller chose a target instead of treating the system as a black box.

## Supported Devices

### `zone-a.yaml`

- Whole-house humidifier controller
- Replace `climate_entity` with your Home Assistant climate entity for this zone

### `zone-b.yaml`

- Whole-house humidifier controller
- Replace `climate_entity` with your Home Assistant climate entity for this zone

## Current Recommended Settings

Balanced settings currently in use for both humidified zones:

- `R_win = 1.55`
- `Headroom RH = 6%`
- `Ceiling RH = 35%`
- `Hysteresis RH = 3.5%`

The current firmware stores the deadband as a half-band. A `3.5%` deadband means:

- relay turns on at `target - 3.5`
- relay turns off at `target + 3.5`

## Wiring Summary

This project assumes a furnace board with `R`, `C`, `W`, `Y`, and `G` terminals but no dedicated `HUM` terminal.

Recommended humidifier interlock:

```text
W terminal
  ->
ESP relay COM
  ->
ESP relay NO
  ->
Humidifier solenoid
  ->
C terminal
```

This ensures water can flow only when both conditions are true:

- a real heat call exists on `W`
- the ESP relay is closed

Do not wire the humidifier directly from `R` to the solenoid for this design.

See [docs/wiring.md](docs/wiring.md) for full details.

## Dashboard Entities

### Control

- `Zone A Control Temperature (Display)`
- `Zone A Measured Control RH`
- `Zone B Control Temperature (Display)`
- `Zone B Measured Control RH`

### Environment

- `Forecast Low Temperature`
- `Estimated Window Surface Temp`
- `Condensation Limit RH`
- `Local Temperature`
- `Local Humidity`

### Targeting

- `Active Humidity Setpoint`
- `Humidifier On Threshold`
- `Humidifier Off Threshold`
- `Maximum Humidity Limit`
- `Condensation Safety Margin`
- `Humidity Half-Deadband`
- `Manual Humidity Setpoint`

### Status

- `Humidifier Running`
- `Humidification Allowed`
- `Forecast Last Updated`
- `Forecast Data Fresh`
- `Forecast Age Minutes`
- `Using Stale Forecast Fallback`
- `Humidity Control Mode`

All user-visible entities in the humidified zones are prefixed with the configured `${zone}` substitution so the example files remain consistent in Home Assistant and can be renamed to match your real zones.

## Installation

### 1. Copy the ESPHome files

Copy the YAML you want from the [`esphome`](esphome) directory into your Home Assistant ESPHome config folder:

- [`esphome/zone-a.yaml`](esphome/zone-a.yaml)
- [`esphome/zone-b.yaml`](esphome/zone-b.yaml)

### 2. Create `secrets.yaml`

Start from [`esphome/secrets.example.yaml`](esphome/secrets.example.yaml) and fill in your own Wi-Fi, OTA, API encryption, and forecast values.

The example secrets file uses placeholder strings only. Replace every value with your own real secrets before validating or flashing.

### 3. Add the device in ESPHome Builder

If using Home Assistant ESPHome Builder:

1. Create a new device entry
2. Replace the generated YAML with the desired file contents
3. Replace the example `climate_entity` value with your actual Home Assistant climate entity
4. Add the matching secrets to ESPHome `secrets.yaml`
5. Optionally add static IP settings if your network requires them
6. Validate and install

### 4. First flash

The first flash is easiest over USB. After that, OTA updates can be used as long as the configured OTA password matches the device.

### 5. Verify Home Assistant entities

After the device comes online, confirm:

- `HVAC Mode` updates
- `Control Temperature` and `Control Humidity` populate
- `Forecast Low Temperature` updates after the first weather fetch
- `Humidity Control Mode` reflects `Automatic` or `Manual`

## Local Build Helper

If you build outside Home Assistant, the included helper avoids ESP-IDF path issues with spaces:

```bash
./tools/esphome-build.sh config esphome/zone-a.yaml
./tools/esphome-build.sh compile esphome/zone-a.yaml
./tools/esphome-build.sh run esphome/zone-a.yaml
```

## Troubleshooting

Common issues are documented in [docs/troubleshooting.md](docs/troubleshooting.md), including:

- OTA password mismatches
- API encryption mismatches
- missing Home Assistant entities
- forecast failures
- stale forecast fallback behavior
- thermostat units and climate attributes

## Calibration and Tuning

See:

- [docs/theory.md](docs/theory.md)
- [docs/tuning.md](docs/tuning.md)
- [docs/calibration.md](docs/calibration.md)

These documents explain:

- dew point and condensation
- what `R_win` really means
- how `Headroom RH`, `Ceiling RH`, and `Deadband` affect comfort and safety
- how to tune aggressively or conservatively

## Safety Disclaimer

This project controls HVAC-adjacent low-voltage wiring and water delivery hardware. Review all wiring carefully before installation. Incorrect furnace or humidifier wiring can damage equipment, create unsafe operating conditions, or cause water damage.

Always verify:

- thermostat terminal functions
- relay contact ratings
- humidifier solenoid voltage
- common and call wiring paths

If you are unsure, consult an HVAC professional.
