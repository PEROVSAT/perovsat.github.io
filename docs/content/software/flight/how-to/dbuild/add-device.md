# Add a Device to DBuild

This guide walks through registering a new logical device in the DBuild system.

For background, see [DBuild overview](../../explanation/dbuild.md) and [Configuration](../../reference/dbuild/configuration.md).

## Overview

Adding a device requires four steps:

1. Register driver west projects in `west.yml` (if the device uses an out-of-tree driver)
2. Create snippets for each supported mode
3. Add the device to the `devices` section of `dbuild.yml`
4. Add a mode selection to the `selections` section of `dbuild.yml`

The MPU6050 IMU is the reference implementation. Use `snippets/mpu6050-*` and the `IMU` entry in `dbuild.yml` as examples.

## 1. Add west driver projects

If the device is backed by an out-of-tree Zephyr module, add it to `west.yml`:

```yaml
- name: mpu6050-driver
  remote: origin
  revision: main
```

The `name` must match the git repository name. Rerun `./setup.sh` or `west update` to clone it into the workspace.

Devices that need only snippets (like FLASH) can skip this step.

## 2. Create snippets

Create one directory per mode under `snippets/`. Naming convention: `<device>-<mode>` (for example `mpu6050-public-mock`).

Each snippet needs:

1. **`snippet.yml`** — declares the snippet name and which files to append
2. **`.conf`** — Kconfig fragments to enable the driver and bus/emulation options
3. **`.overlay` file(s)** — devicetree wiring

For `public-mock`, `library-mock`, or modes with a single emulated bus, one root `.overlay` is usually enough.

For `hardware` or `simulation`, add `boards/<board>.overlay` for each supported board and list those boards in `snippet.yml`. See [Snippets](../../reference/dbuild/snippets.md) for examples.

Each mode that uses a driver backend should have a matching `kconfig_backend` symbol in the driver (for example `CONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK`).

## 3. Add the device to `devices`

Add an entry under `devices` in `dbuild.yml`:

```yaml
devices:
  LOGICAL_NAME:
    west_project: <repository_name>
    modes:
      public-mock:
        snippet: <snippet_name>
        kconfig_backend: CONFIG_PEROVSAT_<DEVICE>_BACKEND_PUBLIC_MOCK
      library-mock:
        snippet: <snippet_name>
        kconfig_backend: CONFIG_PEROVSAT_<DEVICE>_BACKEND_LIBRARY_MOCK
      hardware:
        snippet: <snippet_name>
        kconfig_backend: CONFIG_PEROVSAT_<DEVICE>_BACKEND_HARDWARE
        board_overlay_required: true
```

Omit `west_project` for snippet-only devices. Omit `kconfig_backend` only if the mode does not select a driver backend.

!!! note "Hardware and simulation modes"
    Set `board_overlay_required: true` so DBuild enforces a matching `boards/<board>.overlay` for the target board.

## 4. Select an initial mode

Add the device to `selections` with a sensible default (usually `public-mock`):

```yaml
selections:
  LOGICAL_NAME: public-mock
```

## 5. Verify

Preview the resolved build command:

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

The output should list your snippet(s) in the `-S` flags and show the expected backend Kconfig symbols. If it looks correct, build:

```bash
west dbuild -b nucleo_u575zi_q
```

If validation fails, see [Troubleshooting](../../reference/dbuild/cli.md#troubleshooting) in the CLI reference.
