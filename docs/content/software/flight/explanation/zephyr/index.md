# Zephyr

Zephyr is the real-time operating system (RTOS) that PEROVSAT flight software runs on. It sits between bare-metal firmware and a full OS like Linux: you get threads, drivers, and a kernel, but the footprint stays small enough for a microcontroller on a CubeSat.

## Why we use Zephyr

- **Hardware abstraction** — DeviceTree and Kconfig let us describe boards and enable features without hard-coding pin maps or `#ifdef` forests in application code.
- **Ecosystem** — West manages a multi-repo workspace; modules extend Zephyr with project-specific drivers and libraries.
- **Simulation** — `native_sim` lets us run much of the flight stack on a developer machine before hardware is available.

For generic Zephyr mechanics (binding syntax, full Kconfig language reference, scheduler internals), prefer the [official Zephyr documentation](https://docs.zephyrproject.org/). Our docs focus on what Zephyr *means for PEROVSAT* and how we use it.

## Core concepts at a glance

| Concept | In one sentence |
|---------|-----------------|
| **West** | Command-line tool for workspace setup, building, and flashing. |
| **Workspace / manifest** | West reads a manifest to clone the repos that make up the full project tree. |
| **Board** | A supported hardware target (PCB + MCU); the build system selects drivers and defaults for it. |
| **DeviceTree** | Hardware described as data; application code refers to devices by name, not pins or addresses. |
| **Overlay** | Project-specific DeviceTree fragments that customize a board for our satellite. |
| **Kconfig / `prj.conf`** | Compile-time options that turn kernel features and drivers on or off. |
| **Module** | An out-of-tree package (often our own) that West pulls in and Zephyr builds with the app. |
| **Snippet** | Reusable build fragments (e.g. a sensor or mock configuration) composed into a build. |
| **Mock driver** | Software stand-in for hardware, used in simulation or tests. |
| **DBuild** | PEROVSAT's wrapper around West for consistent builds; see [DBuild reference](../../reference/dbuild.md). |

## Deeper reading

- [DeviceTree](devicetree.md) — overlays, bindings, aliases, and how we map hardware to application names
- [Kconfig](kconfig.md) — `prj.conf`, feature flags, and project conventions
- [Modules](modules.md) — what modules are and how they appear in our workspace
- [Native simulation](native-sim.md) — `native_sim`, mock drivers, and running FSW on your machine

## Related how-tos

- [Add a device to dbuild](../../how-to/add-device-to-dbuild.md) — register hardware in DeviceTree and wire it into the build
