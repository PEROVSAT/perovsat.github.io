# System Health Thread

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

System Health is the always-on coordinator thread. It keeps the EPS alive, maintains mission-wide state, and decides which other threads should be running.

## Responsibilities

- Send the EPS heartbeat (Layer 1 watchdog — power cycle if missed)
- Feed Zephyr / task watchdogs
- Read RTC to set `DEPLOY_COMPLETE`
- Read EPS power data to set `OP_STATUS` (**SAFE**, **LOW**, **NOMINAL**, **HIGH**)
- Start or ensure started: Payload (always), DFA, Communications, Commands (when flags allow)
- Reduce MCU clock speed in **SAFE** / **LOW** modes

## Wake pattern

Interval: roughly 1–5 epochs per cycle.

## Dependencies

- EPS driver (battery info in, heartbeat and power control out)
- Global flags consumed by all other application threads

See also [Power Management](../../reliability/power-management.md) and [PEROVSAT FDIR Strategy](../../reliability/perovsat-strategy.md).
