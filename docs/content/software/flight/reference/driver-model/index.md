# Driver Model Reference

Updated: 7/10/26

## Repository Layout

Repos generated from [driver-template](https://github.com/PEROVSAT/driver-template) share a common layout. The MPU6050 driver follows this structure.

### File tree

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

## Instance Definition
The template code may need an adjustment to the DeviceTree Instance Definition if the driver uses the Sensor API

| Macro | Use |
|-------|-----|
| `DEVICE_DT_INST_DEFINE` | Generic Zephyr device with a custom API struct |
| `SENSOR_DEVICE_DT_INST_DEFINE` | Sensor API driver (e.g. MPU6050) |

## Related

- [DBuild](../dbuild/index.md) — per-device mode selection and snippet wiring
- [Driver catalog](../drivers/index.md) — mission-specific API references
