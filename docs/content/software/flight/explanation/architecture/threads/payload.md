# Payload Thread

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The Payload thread collects sensor and instrument readings and writes raw data to LittleFS. It also manages payload device power when it is the sole consumer of those devices.

## Responsibilities

Behavior depends on `OP_STATUS` (set by System Health):

| Status | Behavior (planned) |
|--------|-------------------|
| **SAFE** | Depower all payload devices |
| **LOW** | Depower AMUs; read IMU, sun sensors, magnetometer; store to LittleFS |
| **NOMINAL** / **HIGH** | Power payload; read sensors; sweep AMUs when sun angle exceeds threshold; store to LittleFS |

## Wake pattern

Interval: 10–60 epochs (exact values TBD).

## Dependencies

- Sensor API (uniform read interface over drivers)
- LittleFS (raw payload files)
- System Health global flags
- Zephyr power management for payload hardware
