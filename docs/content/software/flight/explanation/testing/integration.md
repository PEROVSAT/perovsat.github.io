# Integration Tests

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Integration tests build the driver as a Zephyr application on a emulated MCU and exercise it through devicetree-defined devices — often with the in-tree **I2C emulator** backend for hardware drivers.

## Driver repos

Each bootstrapped driver includes `tests/integration/`:

- Platform: **`qemu_cortex_m3`**
- Hardware drivers: enable `CONFIG_*_EMUL_BACKEND_INTEGRATION` and use an overlay wiring `zephyr,i2c-emul-controller`
- Mock drivers: instantiate the mock node directly in `app.overlay`

```bash
west twister -T tests/integration -p qemu_cortex_m3
```

These tests catch devicetree, Kconfig, and driver API wiring issues that unit tests miss.

See [Driver Model](../driver-model.md).
