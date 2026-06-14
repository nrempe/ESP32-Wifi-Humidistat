# Troubleshooting

## OTA Upload Fails With `Authentication invalid`

Cause:

- the device was flashed earlier with a different OTA password

Fix:

1. Check the OTA password in `secrets.yaml`
2. Confirm it matches the running device
3. If you do not know the old password, flash once over USB

## Device Shows API Handshake or Connection Errors

If you still see:

- successful OTA
- successful API connection
- normal entity updates

then brief socket warnings during boot are usually harmless reconnect noise between the device and Home Assistant.

If the device stays unavailable, check:

- API encryption key
- Wi-Fi reachability
- IP address conflicts
- Home Assistant ESPHome integration status

## Missing Home Assistant Entities

Check:

1. The correct YAML was flashed
2. The device connected through the ESPHome API
3. The zone prefix is what you expect
4. Home Assistant finished reloading the device

If only one zone is affected, confirm that its climate entity and API key match the YAML and `secrets.yaml`.

## Forecast Stops Updating

Possible causes:

- invalid `owm_forecast_url`
- network connectivity issue
- transient HTTP error

Expected behavior:

- forecast age rises
- `Forecast Data Fresh` turns off
- `Using Stale Forecast Fallback` turns on
- target falls back to `Stale Forecast RH Limit`

## Control Temperature or Humidity Missing at Startup

This is normal immediately after boot.

The firmware waits for Home Assistant values before computing the active target. During that brief startup period, the log may show:

```text
Control temperature/humidity not ready yet; skipping target recompute.
```

## Humidifier Does Not Run in Cooling Mode

This is intentional.

The control logic only allows humidification when:

```text
HVAC Mode == heat
```

## Humidifier Turns Off on Invalid Inputs

This is also intentional.

If the control humidity or active target becomes invalid while the device is in `heat`, the relay is forced off as a fail-safe.

## Builder vs Local Files

The YAML files in this repository are standalone. They are designed to paste directly into Home Assistant ESPHome Builder and do not require `packages:` includes.
