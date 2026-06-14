# Flight Software Architecture

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT flight software runs on [Zephyr RTOS](https://docs.zephyrproject.org/) as a multi-threaded application. Application logic is split into cooperating threads; hardware access goes through custom and stock Zephyr drivers.

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

Build-time device selection (mock vs hardware vs emulation) is handled separately by [dbuild](../../reference/dbuild.md); application source does not change between modes.
