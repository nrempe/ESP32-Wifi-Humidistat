# Changelog

## 2026-06-14

- Created public-release repository structure
- Added standalone ESPHome device YAMLs for `Zone A` and `Zone B`
- Added `secrets.example.yaml` for safe public sharing
- Added documentation for theory, tuning, wiring, dashboard layout, calibration, and troubleshooting
- Added local build helper for ESPHome builds outside Home Assistant
- Documented the furnace `W` interlock strategy for safe humidifier control
- Preserved Builder-friendly standalone YAML files instead of `packages`-based includes

## 2026-05-25

- Refined humidifier control logic
- Added heat-only humidification gating
- Added stale forecast fallback behavior
- Added forecast freshness tracking and display entities
- Added fail-safe relay-off behavior when control inputs become invalid
- Cleared stale physics-derived values during forecast fallback mode
