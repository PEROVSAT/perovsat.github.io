# PEROVSAT FDIR Strategy

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Software FDIR on PEROVSAT layers mitigations from the EPS down to individual threads. Hardware must provide ECC flash, watchdog support, and (ideally) latch-up protection on power rails.

## Watchdog layers

| Layer | Mechanism | Action on timeout |
|-------|-----------|-------------------|
| 1 | EPS heartbeat | Full OBC power cycle |
| 2 | MCU internal watchdog | Microcontroller reset |
| 3 | Zephyr Task WDT | Per-thread recovery callback, then MCU reset |

System Health feeds Layer 1 and registers application threads with Layer 3 via `task_wdt_feed()`.

## Software techniques (planned)

- **Safe-mode boot** — subsystems start conservatively and self-check before nominal operation
- **Variable duplication** — triple-modular redundancy on critical state
- **Memory scrubbing** — periodic reads to let ECC correct SRAM before multi-bit upsets
- **I2C bit-banging recovery** — clock out a stuck slave to release the bus

## Hardware expectations

| Requirement | Purpose |
|-------------|---------|
| ECC flash | Protect program storage and flash controller logic |
| EPS heartbeat contract | Last-resort power cycle |
| LCL / overcurrent (TBD on EPS) | SEL protection |

## Open questions

- Which techniques are implemented in v1 flight software vs deferred.
- Exact Task WDT channel assignment per thread.
