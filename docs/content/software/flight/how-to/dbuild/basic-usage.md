# Basic DBuild Usage

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

`west dbuild` wraps `west build` and applies snippet flags from your device configuration.

## 1. Set device modes

Edit `dbuild_devices.conf` at the app root. Use `mock` when you lack hardware or private driver access:

```ini
IMU=mock
```

## 2. Preview the build

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

Fix any validation errors before building.

## 3. Build

```bash
# Linux / WSL — run on host
west dbuild -b native_sim -t run

# Any supported board
west dbuild -b nucleo_u575zi_q
west flash
```

## Tips

- Default pristine policy is `-p always` so snippet changes always produce a matching binary. Use `-p never` for faster incremental rebuilds when modes are unchanged.
- Pass extra CMake args after `--`, for example `west dbuild -b native_sim -- -DCONFIG_LOG_DEFAULT_LEVEL=4`.

See [The DBuild Command](../../reference/dbuild.md) for full CLI and validation rules.
