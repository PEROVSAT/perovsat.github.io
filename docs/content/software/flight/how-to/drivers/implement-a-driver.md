# Implement a Driver

Updated: 7/10/26

Walkthrough for creating and filling in a PEROVSAT driver repository.

For conceptual background, see [Driver Model overview](../../explanation/driver-model.md). For code details, see the [driver model reference](../../reference/driver-model/index.md).

## Create from Template

In GitHub, create the new repository. On the creation page, open the template dropdown and select `driver-template`. Name it `<chip>-driver` after the physical device (for example `mpu6050-driver`), not a mission role like IMU.

In `perovsat-app/west.yml`, add a project block:

```yaml
    - name: <chip>-driver
      remote: origin
      revision: main
```

The `name` must match the repository name. From `perovsat-app`, rerun workspace setup (or `west update`), activate the workspace venv, enter the new repo, and run the driver setup script:

```bash
./setup.sh
source ../.venv/bin/activate
cd ../<chip>-driver/
python setup.py
```

`setup.py` must run inside an activated virtual environment — it installs `pre-commit` with pip. You will be prompted for:

| Prompt | Meaning | Example |
|--------|---------|---------|
| `device-model` | Lowercase slug for filenames and C symbols | `mpu6050` |
| `devicetree-vendor` | Vendor prefix in the `compatible` string | `invensense` |

The module name is set automatically to `<device-model>-driver`.

Then commit the set-up driver. Pre-commit may reformat files on the first commit — stage again and commit:

```bash
git add .
git commit -m "Template clone"
git add .
git commit -m "Template clone"
git push
```

## Communication Bus Setup

### Binding

In `dts/bindings/<vendor>,<chip>.yaml`, include the bus binding your device sits on and declare any properties you will read from devicetree:

```yaml
compatible: "<vendor>,<chip>"
include: i2c-device.yaml
# on-bus: i2c   # if required by the bus binding

properties:
  # FILL IN: mirror fields you will put in struct <chip>_config
```

### Config struct and Kconfig

In `src/<chip>.h`, define read-only config and mutable runtime state. Include bus-specific fields only for backends that need them:

```c
#if defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_HARDWARE)
	struct i2c_dt_spec bus;
#endif
```

Wrap library-only fields in `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)`.

In `src/Kconfig`, uncomment or add a bus `select` for the subsystem the hardware backend needs:

```kconfig
config PEROVSAT_<CHIP>
	bool "<CHIP> driver"
	depends on DT_HAS_<…>_ENABLED
	select I2C
```

Use `select SPI`, `select UART`, etc. when the device is not on I2C. The template ships with `# select I2C` commented out — leave it commented only if the driver has no bus dependency.

In the per-instance init macro in `src/<chip>.c`, populate the bus field for hardware (the template leaves a `FILL IN` comment):

```c
IF_ENABLED(CONFIG_PEROVSAT_<CHIP>_BACKEND_HARDWARE,
	   (.bus = I2C_DT_SPEC_INST_GET(inst),))
```

## Build the API and Public Mock

Choose an API shape and implement the public-mock path first so the driver shell registers and returns static data before any library work:

- [Expose a Sensor API](sensor-api.md) — Zephyr Sensor channels (`sample_fetch` / `channel_get`)
- [Expose a Custom API](custom-api.md) — custom function table (template default)

For public mock, `init()` should return `0` with no transfer or library calls (already the template default). API functions return hardcoded values in the `#else` / public-mock branch.

## Add to DBuild and Verify Public Mock

Follow the [Add a device](../dbuild/add-a-device.md) guide, then build with the logical device set to `public-mock`:

```bash
west dbuild -b qemu_cortex_m3 --dry-run
west dbuild -b qemu_cortex_m3 -t run
```

## Scaffold Library and Backends

The template already created the skeleton files. This step declares the library surface your API will call and notes what each transfer file is for — leave real protocol logic for the next section.

### Device library stubs

In `lib/<chip>_lib.h`, keep the existing `transfer_fn` typedef and `lib_init` declaration. Add declarations for every protocol function the driver shell will need (fetch, read, configure, etc.):

```c
int <chip>_lib_sample_fetch(<chip>_transfer_fn transfer, void *ctx, /* outputs… */);
```

In `lib/<chip>_lib.c`, add matching stubs that validate arguments and return `-ENOTSUP` (or `0` with empty bodies). Do not implement register sequences yet:

```c
int <chip>_lib_sample_fetch(<chip>_transfer_fn transfer, void *ctx, /* outputs… */)
{
	if (transfer == NULL) {
		return -EINVAL;
	}

	ARG_UNUSED(ctx);
	return -ENOTSUP;
}
```

`lib_init` is already stubbed to check `transfer != NULL` and return `0`. Leave the probe/config `FILL IN` for the next section.

### Transfer backends

Each non–public-mock backend already exports `<chip>_transfer` and `<chip>_transfer_init` from `src/transfer.h`. Confirm the files exist and understand their roles — do not fill them in yet beyond what you need to compile:

| File | Role when you implement |
|------|-------------------------|
| `hardware_transfer.c` | Real bus I/O (for example `i2c_write_read_dt`); `transfer_init` checks bus readiness |
| `lib_mock_transfer.c` | In-memory `register_map[]` (already implemented); later seed values `lib_init` expects |
| `simulation_transfer.c` | Socket I/O to Basilisk (stub returns `-ENOTSUP` until SITL is wired) |

CMake already compiles the matching transfer file and `lib/<chip>_lib.c` when a non–public-mock backend symbol is set. No CMake edits are required for the standard four backends.

### Driver shell wiring

The template `init()` already calls `transfer_init` then `lib_init` for library-backed backends. Once your API functions exist, call the new library stubs from the non–public-mock branch (they can still return `-ENOTSUP`). Public mock continues to bypass transfer and library entirely.

## Implement Library Logic

This is the primary work of driver creation. Fill in register constants, `lib_init` probing/configuration, fetch/read sequences via `transfer(ctx, reg, buf, len, read)`, hardware and simulation transfer bodies, and library-mock register-map seeds. Use the MPU6050 driver as the reference for a complete Sensor API implementation.
