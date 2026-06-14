# Simulation Software

Documentation for PEROVSAT simulations — modeling mission dynamics and connecting external simulators to flight software.

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

## Purpose

The separate **`simulation`** GitHub repository hosts setup for running **[Basilisk](https://basilisk-arizona.readthedocs.io/)** (or similar) alongside firmware builds that use **SITL emulator backends** on drivers.

This enables software-in-the-loop testing: simulated physics feed sensor buses while the real flight software binary runs on QEMU or hardware.

## Relationship to flight software

| Flight software piece | Simulation role |
|-----------------------|-----------------|
| SITL emulator backend (`*_emul.c`) | Socket I/O between firmware and simulator |
| dbuild emulation snippets | Select SITL Kconfig in `perovsat-app` |
| `tests/sitl` in driver repos | Build-only verification of SITL images |

See [SITL Testing](../flight/explanation/testing/sitl.md) and [Hardware-in-the-Loop](../flight/explanation/testing/hil.md).

## Open questions

- Clone/setup instructions for the `simulation` repo
- Launch procedure (Basilisk + QEMU + firmware)
- Which subsystems are modeled vs stubbed in v1
