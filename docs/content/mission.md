# Mission Overview 

This document covers the PEROVSAT mission at the highest level. A lot of this information may also be found on the [main site](perovsat.github.io), but this will cover it in a bit more detail here.

## Scientific Goal

[Perovskites](https://en.wikipedia.org/wiki/Perovskite_solar_cell) are an experimental type of solar cell that has the potential to be highly efficient and cheaply manufactured. On the ground, the main issue has been how they can degrade over time due largely to heat and humidity.

PEROVSAT will be evaluating their vaiability in space by measuring their degradation under different thermal conditions. The **+Z** (top) sees prolonged but infrequent sun exposure (causing extensive temperature fluctuations). In contrast, the **-X** (side) freely rotates, and thus sees frequent short bursts of sun exposure.

## Onboard Sensors

Of course, the most crucial scientific payload on PEROVSAT are the Perovskite cells themselves, which we measure using microcontrollers called Aerospace Measurement Units (AMUs). These also enable us to place tiny thermometers alongside the cells which we can read at the same time.

Next, the sun sensors (one on each payload face) supply both the angle and intensity of the sun at any given moment. Analysis of the intensity tells us how much *total* exposure the cells have seen.

Finally, the Intertial Measurement Unit (IMU) supplies data on the rotational speed of the spacecraft. We use the IMU both for telemetry and as a backup for being able to simulate temperatures/sun exposure on a face, should the sun sensors or thermometers fail during the mission.
