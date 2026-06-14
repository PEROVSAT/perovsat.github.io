# Zephyr on PEROVSAT

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT flight software is a Zephyr application built with **west**. These pages summarize Zephyr concepts the team uses daily; official docs remain the authoritative reference.

## Topics

- [Drivers](drivers.md) — device model, registration, and application access
- [Devicetree](devicetree.md) — hardware description, overlays, and aliases
- [Kconfig](kconfig.md) — compile-time feature selection
- [Threads](threads.md) — `K_THREAD_DEFINE`, sleep, and message queues

Additional design notes live in `design-and-planning/info/zephyr/`.

## Workspace layout

After `setup.sh`, the west workspace contains `zephyr/`, HAL modules, `perovsat-app/`, and cloned driver repos listed in `west.yml`.
