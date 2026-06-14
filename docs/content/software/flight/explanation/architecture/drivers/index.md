# Custom Drivers

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT combines stock Zephyr bus drivers with out-of-tree modules for mission hardware. Bus drivers handle pins and protocols; custom drivers expose C APIs the application and middleware use.

## Stack

```text
Application / middleware
    ↓
Custom drivers (EPS, Eyestar, AMU, IMU, sun sensors, …)
    ↓
Zephyr bus drivers (UART, I2C, QSPI/OSPI)
```

## Driver inventory

| Driver | Bus | Role |
|--------|-----|------|
| [EPS](eps.md) | UART | Power system interface, heartbeat, battery telemetry |
| [Eyestar](eyestar.md) | UART | Iridium modem send/receive |
| [AMU](amu.md) | I2C | Multi-channel analog measurement units |
| [IMU](imu.md) | I2C | Attitude / motion sensing |
| [Sun sensor](sun-sensor.md) | UART or other | Sun angle / exposure inputs |

Mock and hardware variants live in separate west projects and are selected at build time via [dbuild](../../../reference/dbuild.md). See [Driver Model](../../../reference/driver-model/index.md) for repo layout and [Creating a Driver](../../how-to/drivers/creation.md) for the workflow.
