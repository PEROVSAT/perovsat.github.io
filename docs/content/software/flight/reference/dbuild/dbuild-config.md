# `dbuild_devices.conf`

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Per-developer (committed) file at the root of `perovsat-app`. Lists which **mode** each logical device uses for the next build.

## Format

```ini
# DEVICE=mode
IMU=mock
```

- Lines are `DEVICE=mode` assignments.
- Comments start with `#`.
- Device names are case-sensitive and must match keys in `device_map.yml`.
- Mode strings are normalized to lowercase (`mock`, `hardware`, etc.).

## Valid modes

Modes are defined per device in `device_map.yml`. Today most devices support `mock` and `hardware`; some hardware drivers also support an emulation path via dedicated snippets.

## Preview without building

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

Override the file path with `-f /path/to/alternate.conf`.

See [The DBuild Command](../dbuild.md).
