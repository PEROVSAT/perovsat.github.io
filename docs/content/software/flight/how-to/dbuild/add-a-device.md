# Wire a Driver into perovsat-app

Updated: 7/10/26

This guide covers the integration of a new device into the [DBuild](../../explanation/dbuild.md) system.

## Prerequisites

- An implemented driver repository (see [Implement a driver](../drivers/implement-a-driver.md))
- A working [PEROVSAT workspace](../../tutorials/getting-started.md)

## Overview

Integration requires three areas of work:

1. Register the driver west project in `west.yml`
2. Create a snippet per supported backend mode
3. Add the logical device to `dbuild.yml`, linking to the correct snippets

The MPU6050 / `IMU` setup in `perovsat-app` is the reference.

## Ensure it's in the West project

You likely already did this in the initial clone, but double check

In `perovsat-app/west.yml`:

```yaml
- name: mpu6050-driver
  remote: origin
  revision: main
```

The `name` must match the driver repository name and `zephyr/module.yml`. Run `west update` or rerun `setup.sh` to clone it.

## Create snippets

Create one directory per mode under `snippets/`. Naming convention: `<chip>-<mode>` (for example `mpu6050-public-mock`).

Each snippet needs:

1. **`snippet.yml`** — registers conf and overlay files
2. **`.conf`** — enables the driver and any bus emulation options
3. **`.overlay`** — instantiates the device and sets the application alias

Look at the other existing snippets for examples or see [DBuild snippets](../../reference/dbuild/snippets.md) for `snippet.yml` structure.

If you want, you can create a DeviceTree alias in the `.overlay` file(s)

## Register in `dbuild.yml`

Add the device under `devices` with a `kconfig_backend` per mode, and add an entry to `selections`

Backend symbol names must match the driver's Kconfig `choice` block exactly.

## Fetch the device in application code

```cpp
const struct device *imu = DEVICE_DT_GET(mpu6050);
const struct device *imu = DEVICE_DT_GET(DT_ALIAS(imu)); // With alias
```

## Verify

Preview the resolved build:

```bash
west dbuild -b qemu_cortex_m3 --dry-run
```

Confirm:

- Your snippet appears in the `-S` list
- The expected `CONFIG_PEROVSAT_<CHIP>_BACKEND_<MODE>=y` symbol is set
- No west-project or board-overlay validation errors

## Related

- [DBuild configuration](../../reference/dbuild/configuration.md) — `dbuild.yml` schema and validation
- [Driver Model overview](../../explanation/driver-model.md)
