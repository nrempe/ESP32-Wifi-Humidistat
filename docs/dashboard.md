# Dashboard

## Recommended Entity Groups

### Control

- `Control Temperature (Display)`
- `Measured Control RH`
- `Humidity Control Mode`

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
- `Condensation Safety Margin`
- `Maximum Humidity Limit`
- `Humidity Half-Deadband`
- `Manual Humidity Setpoint`
- `Stale Forecast RH Limit`

### Status

- `Humidifier Running`
- `Humidification Allowed`
- `Forecast Last Updated`
- `Forecast Data Fresh`
- `Forecast Age Minutes`
- `Using Stale Forecast Fallback`

## Naming Convention

All user-visible entities for the humidified zones are automatically prefixed by `${zone}` in the YAML.

Examples:

- `Zone A Control Temperature (Display)`
- `Zone A Measured Control RH`
- `Zone B Estimated Window Surface Temp`
- `Zone B Humidifier Running`

## Entity Consistency Check

`Zone A` and `Zone B` are intended to be identical except for:

- zone name
- climate entity
- API/OTA credentials
- manual target default

If one example zone ever appears to miss entities in Home Assistant, compare:

- device YAML loaded in ESPHome Builder
- API encryption key
- whether Home Assistant has refreshed its ESPHome device registry after a reflash

## Suggested Card Layout

```text
Row 1: Control Temperature, Measured Control RH, Active Humidity Setpoint
Row 2: Forecast Low Temperature, Estimated Window Surface Temp, Condensation Limit RH
Row 3: Humidifier On Threshold, Humidifier Off Threshold, Humidifier Running
Row 4: Forecast Last Updated, Forecast Data Fresh, Forecast Age Minutes
Row 5: Local Temperature, Local Humidity, Humidity Control Mode
```
