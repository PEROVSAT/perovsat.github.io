# Driver Testing Scaffold

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Every bootstrapped driver repo includes Twister-ready tests.

## Directories

| Path | Platform | `testcase.yaml` notes |
|------|----------|----------------------|
| `tests/unit` | `native_sim` | Fast logic tests |
| `tests/integration` | `qemu_cortex_m3` | Devicetree + emulator |
| `tests/sitl` | `qemu_cortex_m3` | `build_only: true` — no Basilisk in CI |

## Common files per test

- `CMakeLists.txt`, `prj.conf` — test app definition
- `src/main.c` — ztest cases
- `app.overlay` or `boards/*.overlay` — device instantiation
- `testcase.yaml` — Twister platform and harness metadata

## Commands

```bash
west twister -T tests/unit -p native_sim
west twister -T tests/integration -p qemu_cortex_m3
west twister -T tests/sitl -p qemu_cortex_m3 --build-only
```

How-to: [Adding Tests](../../how-to/drivers/adding-tests.md). Concepts: [Testing](../../explanation/testing/index.md).
