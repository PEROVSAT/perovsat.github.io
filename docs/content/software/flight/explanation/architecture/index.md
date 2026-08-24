# Flight Software Architecture

PEROVSAT flight software runs on [Zephyr RTOS](https://docs.zephyrproject.org/), split into threaded application code and driver code

## High-level layout

```text
Application threads  →  middleware (Sensor API, LittleFS, watchdogs)
                      →  custom drivers (EPS, Eyestar, AMU, …)
                      →  Zephyr bus drivers (UART, I2C, SPI/QSPI)
```

An **epoch** is the basic timing unit between thread wakeups (likely one second). **System Health** reads power and deployment state from the EPS, sets global operating flags, and starts or stops other threads accordingly.

## Sections

- [Threads](threads/index.md) — roles, wake conditions, and dependencies for each application thread
- [Drivers](drivers/index.md) — custom device drivers and how they sit on Zephyr buses

Build-time device selection (mock vs hardware vs emulation) is handled separately by [DBuild](../dbuild/index.md); application source does not change between modes.
