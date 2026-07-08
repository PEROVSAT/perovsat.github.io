# Implement a Driver

Walkthrough for creating and filling in a PEROVSAT driver repository. Follow the sections in order; the MPU6050 driver (`mpu6050-driver`) demonstrates each step.

For conceptual background, see [Driver Model overview](../../explanation/driver-model.md). For code-level detail, see the [driver model reference](../../reference/driver-model/index.md).

## 1. Bootstrap from template

Clone [`driver-template`](https://github.com/PEROVSAT/driver-template) and run `setup.py` inside an activated Python virtual environment (the `perovsat-workspace` venv from [Getting Started](../../tutorials/getting-started.md) works). `setup.py` installs `pre-commit` with pip and must run inside a venv.

Name the directory after the physical device, not a mission role like IMU:

```bash
git clone git@github.com:PEROVSAT/driver-template.git mpu6050-driver
cd mpu6050-driver
source /path/to/perovsat-workspace/.venv/bin/activate
python setup.py
```

You will be prompted for:

| Prompt | Meaning | Example |
|--------|---------|---------|
| `device-model` | Lowercase slug for filenames and C symbols | `mpu6050` |
| `devicetree-vendor` | Vendor prefix in the devicetree `compatible` string | `invensense` |

The module name is set automatically to `<device-model>-driver`.

`setup.py` substitutes tokens (`__DRIVER_SLUG__`, `__KCONFIG_SYM__`, etc.), promotes `README.driver.md` to `README.md`, removes itself, initializes a fresh git repository (unless already inside a west workspace), and installs pre-commit hooks. See [Template tokens](../../reference/driver-model/repository-layout.md#template-tokens) for the full token list.

| Name this… | After… | Example |
|------------|--------|---------|
| Git repository | Physical chip | `mpu6050-driver` |
| Logical device in `perovsat-app` | Mission role | `IMU` in `dbuild.yml` |
| Devicetree alias in app overlays | How application code refers to it | `imu = &mpu6050` |

## 2. Setup

### Devicetree binding

Edit `dts/bindings/<vendor>,<chip>.yaml`. Define the `compatible` string, bus include, and properties the driver reads at compile time.

```yaml
compatible: "zephyr,mpu6050"
include: i2c-device.yaml
on-bus: i2c

properties:
  accel-fs:
    type: int
    default: 2
    enum: [2, 4, 8, 16]
```

The `compatible` must match the nodes in `perovsat-app` snippet overlays and `DT_DRV_COMPAT` in the driver `.c` file. See [Devicetree binding](../../reference/driver-model/kconfig-and-devicetree.md#devicetree-binding).

### Config and data structs

In `src/<chip>.h`, define read-only config and mutable runtime state. Mirror binding properties in `struct <chip>_config` using fields you will populate with `DT_INST_PROP`.

Include bus-specific fields only for backends that need them:

```c
#if defined(CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE)
	struct i2c_dt_spec bus;
#endif
```

Wrap library-only fields in `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)`.

### Kconfig

In `src/Kconfig`:

- Add `depends on DT_HAS_<COMPAT>_ENABLED` on the root enable symbol
- Add `select I2C` (or SPI, UART, etc.) for the bus the device uses
- Confirm all four backend symbols are present in the `choice` block

See [Kconfig structure](../../reference/driver-model/kconfig-and-devicetree.md#kconfig-structure).

## 3. Public mock first

Get `public-mock` working before implementing the library and transfer backends. The template provides stub implementations; fill in hardcoded API responses in `src/<chip>.c` so the driver shell registers and returns static data.

In `init()`, return `0` with no transfer or library calls.

Implement the Zephyr or custom API with `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)` to split library-backed implementations from hardcoded public-mock responses. See [Expose an API](expose-an-api.md) for Sensor API vs custom API patterns.

Complete the per-instance registration macro with `DT_INST_PROP` for each binding property:

```c
DT_INST_FOREACH_STATUS_OKAY(MPU6050_INIT)
```

See [Driver registration](../../reference/driver-model/kconfig-and-devicetree.md#driver-registration).

## 4. Library and transfer backends

### Device library

Implement protocol logic in `lib/<chip>_lib.c`:

- Register addresses and constants in `lib/<chip>_lib.h`
- `lib_init()` — probe the device and apply configuration using the injected transfer callback
- Fetch/read functions — burst reads and parsing, all via `transfer(ctx, reg, buf, len, read)`

See [Device library](../../reference/driver-model/device-library.md).

### Transfer backends

Fill in one file per non–public-mock backend under `src/`:

| File | Backend | Implement |
|------|---------|-----------|
| `hardware_transfer.c` | `hardware` | Real bus I/O (for example `i2c_write_read_dt`) |
| `lib_mock_transfer.c` | `library-mock` | In-memory `register_map[]`; seed WHO_AM_I and other values `lib_init` expects |
| `simulation_transfer.c` | `simulation` | Socket protocol to external simulator (stub until SITL is wired) |

Each file exports `<chip>_transfer` and `<chip>_transfer_init` declared in `transfer.h`.

For `library-mock`, seed the register map in `transfer_init` so `lib_init` can probe successfully without hardware. The MPU6050 driver sets `0x75` (WHO_AM_I) and power-management defaults.

See [Transfer contract](../../reference/driver-model/backends.md#transfer-contract).

## 5. Driver shell wiring

In `src/<chip>.c`, wire library backends in `init()`:

```c
ret = mpu6050_transfer_init(dev);
if (ret < 0) return ret;
return mpu6050_lib_init(mpu6050_transfer, dev, …);
```

For MPU6050, implement `struct sensor_driver_api` with `sample_fetch` and `channel_get`. See [Expose an API](expose-an-api.md).

## 6. Verify

After [wiring into perovsat-app](wire-into-application.md), set the logical device to `public-mock` in `dbuild.yml` and build:

```bash
west dbuild -b qemu_cortex_m3 --dry-run
west dbuild -b qemu_cortex_m3 -t run
```

Resolve any validation errors using [DBuild troubleshooting](../../reference/dbuild/cli.md#troubleshooting).

## Next steps

- [Expose an API](expose-an-api.md) — Sensor API or custom function table
- [Wire into perovsat-app](wire-into-application.md) — west manifest, snippets, aliases, and `dbuild.yml`
