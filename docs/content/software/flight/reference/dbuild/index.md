# DBuild Reference

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

DBuild (Device Build) is PEROVSAT's west extension for selecting per-device mock, hardware, or emulation modes at build time.

## Pages

- [The DBuild Command](../dbuild.md) — full command reference, validation, and CLI
- [Device Configuration](dbuild-config.md) — `dbuild_devices.conf` format
- [Device Map](device-map.md) — `dbuild/device_map.yml` schema
- [Snippets](snippets.md) — snippet directory layout and Zephyr integration

## Data flow

```text
dbuild_devices.conf  →  device_map.yml  →  snippets/*  →  west build -S ...
```

Application C code stays the same; only devicetree aliases and Kconfig fragments change between modes.

## How-to

- [Basic Usage](../../how-to/dbuild/basic-usage.md)
- [Add a device to dbuild](../../how-to/add-device-to-dbuild.md)
