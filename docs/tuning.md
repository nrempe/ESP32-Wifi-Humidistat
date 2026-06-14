# Tuning

## Main Tuning Parameters

### `R_win`

This controls how cold the model thinks the most condensation-prone window surface is.

- lower `R_win` means colder modeled glass
- higher `R_win` means warmer modeled glass

Effects:

- lower `R_win` lowers allowed RH
- higher `R_win` raises allowed RH

### `Headroom RH`

This subtracts a safety margin from the calculated condensation limit.

Effects:

- larger headroom is safer but drier
- smaller headroom is more comfortable but riskier

### `Ceiling RH`

This is the maximum humidity target the system is allowed to use, even if the windows could tolerate more.

Effects:

- lower ceiling reduces moisture in the home
- higher ceiling increases comfort but can raise risk in hidden cold spots

### `Humidity Half-Deadband`

This is the relay half-band around the active target.

If target is `35%` and deadband is `3.5%`:

- humidifier turns on below `31.5%`
- humidifier turns off above `38.5%`

## Recommended Presets

### Conservative

Use this if you have older windows, frequent condensation, or want a safer starting point.

```text
R_win = 1.4
Headroom = 8
Ceiling = 35
```

### Balanced

Recommended for the current project baseline.

```text
R_win = 1.55
Headroom = 6
Ceiling = 35
```

### Aggressive

Use this only after observing clean window performance for a while.

```text
R_win = 1.8
Headroom = 4
Ceiling = 40
```

## Suggested Tuning Workflow

1. Start conservative or balanced.
2. Watch the coldest window edges during colder weather.
3. If no condensation appears and the home feels too dry:
   - reduce `Headroom RH`, or
   - increase `R_win` slightly
4. If condensation appears:
   - lower `R_win`, or
   - increase `Headroom RH`, or
   - lower `Ceiling RH`

Make one change at a time and observe for at least a few weather cycles.

## Practical Advice

- `R_win` is the most physical tuning parameter
- `Headroom RH` is the easiest operational safety adjustment
- `Ceiling RH` is the simplest comfort cap
- `Deadband` affects cycling behavior, not condensation physics

## Current Recommended Settings

For this project:

```text
R_win       = 1.55
Ceiling RH  = 35%
Headroom RH = 6%
Hysteresis  = 3.5%
```
