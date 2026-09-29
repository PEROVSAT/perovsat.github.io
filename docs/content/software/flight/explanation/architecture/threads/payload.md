# Payload Thread

Updated: 9/29/26

The payload thread reads and saves data from payload hardware, including:

- AMUs - Read Perovskite IV curves and temperatures
    - Only take reads if sun sensors indicate high sun angle
- IMU - For tumbling telemetry in case of sun sensor failure
- Some sort of sun measurements - Current design is undergoing changes

## Power Status Behavior

| Status | Behavior (planned) |
|--------|-------------------|
| **SAFE** | Depower all devices |
| **LOW** | Depower AMUs and IMU, read sun data |
| **NOMINAL** / **HIGH** | Full operation |

## Wake pattern

Interval: 10–60 epochs

## Dependencies

- AMU, IMU, and Sun Sensor Drivers - Readings and power control
- LittleFS - Write raw payload data
