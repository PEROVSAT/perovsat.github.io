# Hardware-in-the-Loop (HIL)

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

HIL connects running flight software to a simulation plant so sensor inputs and actuator outputs are exercised under realistic dynamics — not just canned emulator responses.

## PEROVSAT approach

The planned stack pairs:

- Firmware built with **SITL emulator backends** (socket I/O instead of physical I2C/UART)
- **[Basilisk](https://basilisk-arizona.readthedocs.io/)** or similar simulation in the separate `simulation` repository

This sits above integration tests (canned emulator) but below full flat-sat hardware tests.

## Open questions

- Exact HIL topology (which devices are simulated vs real), launch scripts, and pass/fail criteria.
- Relationship between HIL and the `simulation` repo vs lab flat-sat setups.

See [Simulation Software](../../../simulation/index.md) and [SITL Testing](sitl.md).
