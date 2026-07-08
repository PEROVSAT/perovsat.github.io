# DBuild

PEROVSAT flight software talks to many devices — IMU, modem, AMU, flash, and more. During development you often want to run without every piece of hardware connected, or to swap between a public mock, a library-backed mock, simulation, and real hardware. DBuild (Device Build) is how you make that choice at build time without changing application source code.

## The problem it solves

Without DBuild, switching between a mock IMU and a real MPU6050 would mean editing Kconfig, devicetree overlays, and possibly which west projects are present — scattered changes that are easy to get wrong. DBuild collects those concerns into one file (`dbuild.yml`) and a `west dbuild` command that resolves everything before CMake runs.

Application C/C++ code stays the same across modes. What changes is:

- **Devicetree** — which device nodes exist and which bus they sit on (via snippets).
- **Kconfig** — which driver backend is active (via snippet `.conf` files and backend symbols).
- **West modules** — which out-of-tree driver repos are required for the selected mode.

## How it fits together

```text
dbuild.yml (selections)  →  resolve per device  →  snippets + backend Kconfig
                                                          ↓
                                                   west build -S … -D…
```

1. **`selections`** in `dbuild.yml` — the modes you want right now (for example `IMU: public-mock`).
2. **`devices`** in `dbuild.yml` — the catalog of valid devices, their modes, snippets, and backend symbols.
3. **Snippets** under `snippets/` — Zephyr configuration bundles (Kconfig fragments and devicetree overlays) applied with `west build -S`.
4. **Backend Kconfig** — each mode can set a `kconfig_backend` symbol (for example `CONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK`) that the driver uses to select its implementation.

`west dbuild` reads your selections, looks up each device in the catalog, validates that snippets and west projects exist, checks board support where required, and runs `west build` with the correct `-S` snippet flags and `-D<backend>=y` CMake arguments.

## Modes

Modes are defined per device in `dbuild.yml`. Common ones include:

| Mode | Typical use |
|------|-------------|
| `public-mock` | Default for new developers; uses open-source mock hardware in devicetree |
| `library-mock` | Mock backed by an NDA library repo (when applicable) |
| `simulation` | Runs in QEMU, will connect to Basilisk for SITL testing in the future |
| `hardware` | Real device on a physical board; requires a per-board overlay |

Not every device supports every mode. FLASH, for example, only defines `simulation` and has no associated west driver project.

## Relationship to drivers

Each device that uses an out-of-tree driver lists a `west_project` in `dbuild.yml`. DBuild verifies that project is in `west.yml`, cloned in the workspace, and contains `zephyr/module.yml`. The driver's Kconfig exposes backend choice symbols; DBuild sets the one that matches your selected mode.

For how to register a new device, see [Add a device to DBuild](../../how-to/dbuild/add-device.md). For file formats and the command line, see the [DBuild reference](../../reference/dbuild/index.md).
