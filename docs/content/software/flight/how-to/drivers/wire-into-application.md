# Wire a Driver into perovsat-app

This guide covers the application-side integration for a new driver: west manifest, snippets, `dbuild.yml`, and devicetree aliases. It complements [Add a device to DBuild](../dbuild/add-device.md), which documents the same `dbuild.yml` steps from the build-system perspective.

## Prerequisites

- An implemented driver repository (see [Implement a driver](implement-a-driver.md))
- A working [PEROVSAT workspace](../../tutorials/getting-started.md)

## Overview

Integration requires four areas of work:

1. Register the driver west project in `west.yml`
2. Create a snippet per supported backend mode
3. Add the logical device to `dbuild.yml`
4. Set a devicetree alias so application code can resolve the device

The MPU6050 / `IMU` setup in `perovsat-app` is the reference.

## 1. Add the west project

In `perovsat-app/west.yml`:

```yaml
- name: mpu6050-driver
  remote: origin
  revision: main
```

The `name` must match the driver repository name and `zephyr/module.yml`. Run `west update` or rerun `setup.sh` to clone it.

## 2. Create snippets

Create one directory per mode under `snippets/`. Naming convention: `<chip>-<mode>` (for example `mpu6050-public-mock`).

Each snippet needs:

1. **`snippet.yml`** — registers conf and overlay files
2. **`.conf`** — enables the driver and any bus emulation options
3. **`.overlay`** — instantiates the device and sets the application alias

### Public mock example

`snippets/mpu6050-public-mock/mpu6050-public-mock.conf`:

```ini
CONFIG_PEROVSAT_MPU6050=y
CONFIG_EMUL=y
CONFIG_I2C_EMUL=y
```

`snippets/mpu6050-public-mock/mpu6050-public-mock.overlay`:

```dts
/ {
	aliases {
		imu = &mpu6050;
	};

	i2c_emul: i2c@100 {
		compatible = "zephyr,i2c-emul-controller";
		/* … */
		mpu6050: mpu6050@68 {
			compatible = "zephyr,mpu6050";
			reg = <0x68>;
			status = "okay";
		};
	};
};
```

The alias (`imu`) is what application code uses with `DT_ALIAS(imu)`. The `compatible` must match the driver binding.

### Hardware example

Hardware snippets use `boards/<board>.overlay` for per-board bus wiring and set `board_overlay_required: true` in `dbuild.yml`:

```dts
/ {
	aliases {
		imu = &mpu6050;
	};
};

&i2c1 {
	status = "okay";
	mpu6050: mpu6050@68 {
		compatible = "zephyr,mpu6050";
		reg = <0x68>;
		status = "okay";
	};
};
```

See [DBuild snippets](../../reference/dbuild/snippets.md) for `snippet.yml` structure.

## 3. Register in `dbuild.yml`

Add the device under `devices` with a `kconfig_backend` per mode:

```yaml
devices:
  IMU:
    west_project: mpu6050-driver
    modes:
      public-mock:
        snippet: mpu6050-public-mock
        kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK
      hardware:
        snippet: mpu6050-hardware
        kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE
        board_overlay_required: true
```

Add an entry to `selections`. Start with `public-mock` for development:

```yaml
selections:
  IMU: public-mock
```

Backend symbol names must match the driver's Kconfig `choice` block exactly.

## 4. Use the device in application code

Resolve the alias at compile time and check readiness at runtime:

```c
const struct device *imu = DEVICE_DT_GET(DT_ALIAS(imu));

if (!device_is_ready(imu)) {
	LOG_ERR("IMU not ready");
	return;
}

sensor_sample_fetch(imu);
```

## 5. Verify

Preview the resolved build:

```bash
west dbuild -b qemu_cortex_m3 --dry-run
```

Confirm:

- Your snippet appears in the `-S` list
- The expected `CONFIG_PEROVSAT_<CHIP>_BACKEND_<MODE>=y` symbol is set
- No west-project or board-overlay validation errors

Build and run:

```bash
west dbuild -b qemu_cortex_m3 -t run
```

For hardware, build and flash separately:

```bash
west dbuild -b nucleo_u575zi_q
west flash
```

See [Running on hardware](../../tutorials/running-hardware.md).

## Checklist

| Step | Location | Done when |
|------|----------|-----------|
| West project listed | `west.yml` | `west update` clones the repo |
| Snippets exist | `snippets/<chip>-<mode>/` | Each mode has conf, overlay, and `snippet.yml` |
| Device registered | `dbuild.yml` `devices` | All modes map to snippet + `kconfig_backend` |
| Default mode set | `dbuild.yml` `selections` | Logical device points to a valid mode |
| Alias set | Snippet overlay | `DT_ALIAS(...)` resolves in application code |
| App uses device | `src/*.cpp` | `DEVICE_DT_GET` + `device_is_ready` + API calls |

## Related

- [Add a device to DBuild](../dbuild/add-device.md) — `dbuild.yml` schema and validation
- [Backends](../../reference/driver-model/backends.md) — what each mode compiles and requires
- [Driver Model overview](../../explanation/driver-model.md)
