# Explanation

Background concepts and design rationale for PEROVSAT flight software.

New to the project? Start with [Fundamental terminology and concepts](fundamentals.md), then open the overview for whichever domain you are working in.

## Topics

### [Fundamentals](fundamentals.md)

Mission vocabulary and links into every explanation area.

### [Zephyr](zephyr/index.md)

RTOS, West, DeviceTree, Kconfig, modules, and simulation.

- [DeviceTree](zephyr/devicetree.md)
- [Kconfig](zephyr/kconfig.md)
- [Modules](zephyr/modules.md)
- [Native simulation](zephyr/native-sim.md)

### [Flight software architecture](architecture/index.md)

Threads, operational status, data flow, and shared mission state.

- [Threads](architecture/threads.md)
- [Operational status](architecture/op-status.md)
- [Data flow](architecture/data-flow.md)
- [Global flags](architecture/global-flags.md)

### [Hardware and payload](hardware/index.md)

EPS, payload instruments, sensors, and communications hardware.

- [Electrical Power System](hardware/eps.md)
- [Payload](hardware/payload.md)
- [Sensors](hardware/sensors.md)
- [Communications](hardware/comms.md)

### [Reliability](reliability/index.md)

Space environment, FDIR, and safe-mode behavior.

- [Space environment](reliability/space-environment.md)
- [FDIR](reliability/fdir.md)
- [Safe mode](reliability/safe-mode.md)

### [Testing](testing/index.md)

SITL, HIL, and how we exercise FSW before flight.

- [Hardware-in-the-loop](testing/hil.md)
