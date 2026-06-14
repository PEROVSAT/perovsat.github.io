# Adding Tests

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

`driver-template` scaffolds three Twister test directories. Extend them as the driver gains behavior.

## Layout

| Directory | Platform | Purpose |
|-----------|----------|---------|
| `tests/unit` | `native_sim` | Pure logic, no hardware |
| `tests/integration` | `qemu_cortex_m3` | Devicetree + driver on emulated MCU |
| `tests/sitl` | `qemu_cortex_m3` | SITL emulator build (`build_only` in CI) |

## Running tests

From the driver repo root inside the west workspace:

```bash
west twister -T tests/unit -p native_sim
west twister -T tests/integration -p qemu_cortex_m3
west twister -T tests/sitl -p qemu_cortex_m3 --build-only
```

## Writing tests

- Use **ztest** (`ZTEST`) in `tests/*/src/main.c`.
- Integration tests use `app.overlay` to instantiate your device node.
- Hardware drivers should enable the integration emulator backend — see [Adding Emulation](adding-emulation.md).

Conceptual overview: [Testing](../../explanation/testing/index.md).
