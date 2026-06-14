# Calibration

## Purpose

Calibration mainly means improving `R_win`, which controls how cold the model thinks the most condensation-prone window surface is.

## Manual Calibration Concept

During cold weather, gather:

- indoor air temperature
- outdoor air temperature
- measured interior glass temperature at the coldest condensation-prone spot

Usually this is near the lower edge of the window, not the center.

## Practical Calibration Method

1. Wait for stable indoor conditions.
2. Measure indoor air temperature near the thermostat reference.
3. Capture outdoor temperature.
4. Measure the inside glass temperature at the coldest problem location.
5. Compare the measured glass temperature to the model's `Estimated Window Surface Temp`.

If the measured glass is colder than the model:

- lower `R_win`

If the measured glass is warmer than the model:

- raise `R_win`

## Signs Your Model Is Too Aggressive

- condensation appears even though the controller claims there is headroom
- windows fog at edges before the target is reduced

## Signs Your Model Is Too Conservative

- no condensation ever appears
- active RH seems much lower than expected
- window temperatures in reality are warmer than the model

## Future Enhancement Idea

A future calibration mode could accept:

- indoor temperature
- outdoor temperature
- measured glass temperature

and compute an updated `R_win` automatically.

That feature is not implemented yet, but this repository is structured so it can be added later.
