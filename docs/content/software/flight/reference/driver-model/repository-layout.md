# Repository Layout

Repos generated from [driver-template](https://github.com/PEROVSAT/driver-template) share a common layout. The MPU6050 driver follows this structure.

## File tree

```text
mpu6050-driver/
├── zephyr/module.yml
├── Kconfig
├── CMakeLists.txt
├── src/
│   ├── CMakeLists.txt
│   ├── Kconfig
│   ├── mpu6050.c
│   ├── mpu6050.h
│   ├── transfer.h
│   ├── hardware_transfer.c
│   ├── lib_mock_transfer.c
│   └── simulation_transfer.c
├── lib/
│   ├── mpu6050_lib.c
│   └── mpu6050_lib.h
└── dts/bindings/
    └── zephyr,mpu6050.yaml
```

| Path | Role |
|------|------|
| `zephyr/module.yml` | Declares the west module name and CMake/Kconfig/devicetree roots |
| `Kconfig` | Top-level entry; sources `src/Kconfig` |
| `CMakeLists.txt` | Top-level entry; adds `src/` when the driver symbol is enabled |
| `src/<chip>.c` | Zephyr driver shell — API, `init()`, device registration |
| `src/<chip>.h` | Config/data structs, API declarations |
| `src/transfer.h` | Transfer function contract shared by driver and backends |
| `src/*_transfer.c` | One file per non–public-mock backend |
| `lib/<chip>_lib.c` | Bus-agnostic protocol and register logic |
| `dts/bindings/` | Devicetree binding YAML for the device `compatible` string |

## `zephyr/module.yml`

```yaml
name: mpu6050-driver
build:
  cmake: .
  kconfig: Kconfig
  settings:
    dts_root: .
```

| Field | Description |
|-------|-------------|
| `name` | West manifest project name; must match the git repository name |
| `build.cmake` | Root `CMakeLists.txt` for the module |
| `build.kconfig` | Root `Kconfig` for the module |
| `settings.dts_root` | Directory containing `dts/bindings/` |

## CMake conditional compilation

`src/CMakeLists.txt` always compiles the driver shell. Transfer backends and the device library compile only when their backend Kconfig symbol is set:

```cmake
zephyr_library_sources(mpu6050.c)
zephyr_library_sources_ifdef(CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE hardware_transfer.c)
zephyr_library_sources_ifdef(CONFIG_PEROVSAT_MPU6050_BACKEND_SIMULATION simulation_transfer.c)
zephyr_library_sources_ifdef(CONFIG_PEROVSAT_MPU6050_BACKEND_LIBRARY_MOCK lib_mock_transfer.c)
zephyr_library_sources_ifdef(CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE ${mpu6050_LIB}/mpu6050_lib.c)
# … same for simulation and library-mock
```

`public-mock` compiles only `mpu6050.c`. No transfer file and no `lib/` sources are linked.

## Template tokens

`driver-template` substitutes tokens across file contents and paths via `setup.py`. The module name is `<device-model>-driver` (for example `mpu6050-driver`). After setup, `setup.py` is removed and `README.driver.md` is promoted to `README.md`.

| Token | Resolves to (MPU6050 example) |

| Token | Resolves to (MPU6050 example) |
|-------|-------------------------------|
| `__MODULE_NAME__` | `mpu6050-driver` |
| `__DRIVER_SLUG__` | `mpu6050` |
| `__DRIVER_UPPER__` | `MPU6050` |
| `__VENDOR__` | `invensense` |
| `__COMPAT__` | `invensense,mpu6050` |
| `__DT_COMPAT__` | `invensense_mpu6050` (for `DT_DRV_COMPAT`) |
| `__DT_HAS_ENABLED__` | `DT_HAS_INVENSENSE_MPU6050_ENABLED` |
| `__KCONFIG_SYM__` | `PEROVSAT_MPU6050` |

See [Implement a driver](../../how-to/drivers/implement-a-driver.md) for bootstrap steps.

## Naming conventions

| Concept | Convention | Example |
|---------|------------|---------|
| Git repository | `<chip>-driver` | `mpu6050-driver` |
| Kconfig root symbol | `CONFIG_PEROVSAT_<CHIP>` | `CONFIG_PEROVSAT_MPU6050` |
| Backend symbols | `CONFIG_PEROVSAT_<CHIP>_BACKEND_<MODE>` | `CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE` |
| Snippet directories | `<chip>-<mode>` | `mpu6050-public-mock` |
| Logical device (in app) | Mission role in `dbuild.yml` | `IMU` |

See [Backends](backends.md) and [Kconfig and devicetree](kconfig-and-devicetree.md).
