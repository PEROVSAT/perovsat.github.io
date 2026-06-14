# Testing

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT tests flight software at several levels, from isolated driver logic to full hardware-in-the-loop runs with Basilisk.

## Test layers

| Layer | Doc | Typical platform |
|-------|-----|------------------|
| Overview | [PEROVSAT Testing](perovsat-testing.md) | — |
| Unit | [Unit Tests](unit.md) | `native_sim` |
| Integration | [Integration Tests](integration.md) | `qemu_cortex_m3` |
| SITL | [SITL](sitl.md) | QEMU + Basilisk socket |
| Hardware | [Hardware Testing](hardware.md) | Dev boards, flight hardware |
| HIL | [Hardware-in-the-Loop](hil.md) | OBC + Basilisk / sim plant |

Driver repos scaffold unit, integration, and (for hardware drivers) SITL tests via `driver-template`. Application-level testing strategy is still evolving.
