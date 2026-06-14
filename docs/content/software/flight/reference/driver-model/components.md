# Driver Module Components

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Repos generated from `driver-template` share this layout:

```text
my-driver/
├── zephyr/module.yml          # West/Zephyr module declaration
├── Kconfig / CMakeLists.txt   # Top-level build integration
├── drivers/<subsystem>/<name>/   # Driver .c/.h, Kconfig, CMakeLists
├── dts/bindings/<subsystem>/  # Devicetree compatible YAML
└── tests/
    ├── unit/
    ├── integration/
    └── sitl/                  # hardware drivers only
```

## Key files

| Artifact | Role |
|----------|------|
| `module.yml` | Tells west where CMake/Kconfig roots live |
| Binding YAML | Defines `compatible` string and devicetree properties |
| Driver `.c` | `DT_DRV_COMPAT`, `init()`, `DEVICE_DT_INST_DEFINE` |
| `*_emul.c` | Bus emulator (hardware drivers only) |

## Token naming

`setup.py` substitutes device name, vendor, compatible string, and Kconfig symbol (`CONFIG_PEROVSAT_<DEVICE>_MOCK`, etc.). See `driver-template` README for the full token table.

## Integration checklist

Each generated README lists steps to add the module to `west.yml`, create snippets, and map the device in `device_map.yml`.
