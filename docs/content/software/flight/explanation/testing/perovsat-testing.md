# PEROVSAT Testing Philosophy

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Testing is split between **driver repos** (device-specific, runnable in CI) and **perovsat-app** (thread integration and mission behavior).

## Principles

- **Mock drivers** let developers build and test application logic without NDA hardware or lab setups.
- **Emulation backends** exercise the real hardware driver code against simulated I2C/UART traffic.
- **dbuild** keeps mock, hardware, and emulation as build-time switches — the same application binary layout, different snippets.
- **Twister** (`west twister`) runs Zephyr test suites across platforms defined in each repo's `testcase.yaml`.

## Where tests live

| Location | What is tested |
|----------|----------------|
| `driver-template` / `*-driver` repos | Driver init, API, emulator, devicetree bindings |
| `perovsat-app` | End-to-end application (TBD — limited coverage today) |
| `simulation` repo | Basilisk ↔ firmware SITL harness (see [Simulation Software](../../../simulation/index.md)) |

## Open questions

- Application-level thread tests and mission scenario tests are not defined yet.
