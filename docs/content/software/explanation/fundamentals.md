# Fundamental terminology and concepts

!!! warning "Under Construction"
    This page is a navigation hub. Detailed explanations live in the topic sections below.

Start here for a map of vocabulary used across PEROVSAT flight-software docs, tutorials, and reference material. Each linked section has a **fundamentals overview** (`index.md`) and deeper articles where needed.

## Mission and platform

Terms that describe what we are building and where it flies.

- **Flight Software (FSW)** — application, subsystem, and driver code that runs on the satellite
- **On-Board Computer (OBC)** — hardware that runs FSW
- **CubeSat / bus** — standardized small-satellite form factor; NSL provides our bus
- **Nearspace Launch (NSL)** — our CubeSat bus provider (frame, EPS, and related infrastructure)
- **Low Earth Orbit (LEO)** — ~400 km; our mission orbit after deployment from the ISS

## Where to go next

| Domain | Overview | What you will find there |
|--------|----------|---------------------------|
| Zephyr and build | [Zephyr](zephyr/index.md) | West, workspace, DeviceTree, Kconfig, modules, DBuild |
| FSW architecture | [Architecture](architecture/index.md) | Threads, OP_STATUS, data flow, global flags |
| Hardware and payload | [Hardware](hardware/index.md) | EPS, AMU, sensors, communications |
| Reliability | [Reliability](reliability/index.md) | FDIR, radiation, watchdogs, safe mode |
| Testing | [Testing](testing/index.md) | SITL, HIL, simulation vs hardware |

## Runtime concepts (covered across sections)

These appear in several places; follow the links above for context.

- **RTOS**, **kernel**, **scheduler**, **thread**
- **Driver**, **Sensor API**, **IPC / message queue**
- **LittleFS**, **wake model** (interval-, event-, and mixed-driven)

For build-time tooling (**snippet**, **mock driver**, **DBuild**), see [Zephyr](zephyr/index.md) and the [DBuild reference](../reference/dbuild.md).
