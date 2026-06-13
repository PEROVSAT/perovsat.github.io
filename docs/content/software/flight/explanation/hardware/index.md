# Hardware and payload

Flight software sits between the **on-board computer (OBC)** and the physical subsystems on the satellite: power, sensors, payload instruments, and the radio. This section explains what those pieces are and how the software thinks about them — not wiring diagrams or full protocol tutorials.

## Bus vs payload

**Nearspace Launch (NSL)** provides the CubeSat **bus**: frame, electrical power system (EPS), and much of the infrastructure we inherit. PEROVSAT adds the **payload** — perovskite cell measurement via the Aerospace **AMU** — plus supporting sensors and a communications modem. FSW must respect EPS limits and heartbeat contracts while driving our science hardware.

## Communication buses

Devices attach over common embedded buses. In documentation we mean the **wiring layer**, not a full protocol guide:

| Bus | Typical use on PEROVSAT |
|-----|-------------------------|
| **I2C** | Sensors, EPS-related interfaces |
| **SPI** | Higher-throughput peripherals where used |
| **UART** | Serial links (e.g. modem) |

Zephyr **drivers** and the **Sensor API** hide register-level details; application code works with named devices and structured readings.

## Subsystems at a glance

| Subsystem | Role |
|-----------|------|
| **EPS** | Power budgeting, distribution, watchdog / heartbeat |
| **AMU / payload** | Perovskite cell measurements |
| **IMU, sun sensor, magnetometer** | Attitude-related sensing (ADCS inputs) |
| **Eyestar modem** | Iridium-based downlink/uplink (SBD) |

## Deeper reading

- [Electrical Power System](eps.md) — EPS, heartbeat, and FSW obligations
- [Payload](payload.md) — AMU and perovskite science context
- [Sensors](sensors.md) — IMU, sun sensor, magnetometer
- [Communications](comms.md) — modem, SBD, beacon
