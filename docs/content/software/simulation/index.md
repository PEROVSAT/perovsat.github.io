# Simulation Software

PEROVSAT's [Basilisk simulation](https://github.com/PEROVSAT/basilisk-simulation) models orbit, passive magnetic
attitude control, solar generation, and battery energy. Python assembles one
vehicle; experiments choose run settings and analyze its output. C++ plugins
model the permanent magnet and hysteresis rods.

**New teammates: start with [Getting started](getting-started.md).**

## Simulation guides

| Guide | Contents |
| --- | --- |
| [Getting started](getting-started.md) | Setup, first run, outputs, troubleshooting |
| [Architecture](architecture.md) | Code map, data flow, units, assumptions |
| [Development](development.md) | Experiments, hardware changes, builds, validation |
| [Power](power.md) | Panels, loads, battery, recorded power |
| [Rod model](rod-model.md) | Flatley–Henretty hysteresis equations and parameters |

These guides are published from the simulation repository's `docs/` directory
and rod-model README at [revision `edb7769`](https://github.com/PEROVSAT/basilisk-simulation/tree/edb77696e55f2cd707afaa19c2074e2f3061f27b).
Source-code links point to that revision so they match the documented behavior.

## Current implementation

The vehicle uses adaptive RKF45 propagation, Basilisk's standard World Magnetic
Model (WMM), SPICE planetary states, and Earth eclipse illumination. A permanent
magnet and eight hysteresis rods provide passive magnetic attitude control.
Three fixed solar panels and constant average electrical loads connect to one
battery. See [architecture](architecture.md) for assumptions and validation limits.

## Vizard

Vizard replays recorded simulation states in 3D. Experiments can request output
with `RunConfig(vizard=True)`; when supported, Basilisk writes a file ending in
`_UnityViz.bin` in the experiment's output directory. Python plots do not require
Vizard. See [Getting started](getting-started.md#read-the-results) for outputs.

## Model background and design notes

The following pages retain background and earlier design work. The guides above
describe the current vehicle; flight-software integration and continuous WMM are
separate design topics.

- [Permanent magnet model](environment/PMAC.md)
- [Earlier Jiles–Atherton rod model](environment/Hysterisis_Rods.md)
- [Continuous WMM design (not integrated)](environment/WMM.md)
- [Basilisk flight-software interface](flight-software-testing/basilisk-flight-software-interface.md)
- [Zephyr-driven synchronization](flight-software-testing/zephyr-driven-synchronization.md)
