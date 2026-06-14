# Reliability and FDIR

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT flight software must tolerate radiation-induced faults in low Earth orbit. Fault Detection, Isolation, and Recovery (FDIR) combines hardware protections with software techniques and layered watchdogs.

## Topics

- [Radiation Events](radiation-events.md) — TID, displacement damage, and single-event effects relevant to LEO
- [PEROVSAT Strategy](perovsat-strategy.md) — watchdog layers, safe-mode boot, and software mitigations
- [Power Management](power-management.md) — how EPS-driven `OP_STATUS` throttles mission behavior

Design notes also live in the public `design-and-planning` repository under `exploration/fdir.md`.
