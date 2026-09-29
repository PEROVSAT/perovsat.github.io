# Driver Model Reference

Updated: 7/10/26

## Repository Layout

Repos generated from [driver-template](https://github.com/PEROVSAT/driver-template) share a common layout. The MPU6050 driver follows this structure.

### File tree

```text
mpu6050-driver/
├── dts
│   └── bindings
│       └── invensense,mpu6050.yaml
├── include
│   └── mpu6050.h
├── lib
│   ├── mpu6050_bus.h
│   └── mpu6050.c
├── mock
│   └── mpu6050.c
├── samples
│   └── repl
│       ├── app.overlay
│       ├── CMakeLists.txt
│       ├── prj.conf
│       ├── sample.yaml
│       └── src
│           └── main.c
├── src
│   ├── CMakeLists.txt
│   ├── hardware_transfer.c
│   ├── Kconfig
│   ├── lib_mock_transfer.c
│   ├── mpu6050_priv.h
│   └── mpu6050.c
├── tests
│   └── unit
│       ├── CMakeLists.txt
│       ├── prj.conf
│       ├── src
│       │   └── main.c
│       └── testcase.yaml
└── zephyr
    └── module.yml
```

| Path | Role |
|------|------|
| `include/<chip>.h` | User-level data structs and API declarations |
| `lib/<chip>.c` | Device-logic implementation of the API |
| `lib/<chip>_bus.h` | Transfer function declaration |
| `src/<chip>.c` | Zephyr boilerplate for device discovery |
| `src/<chip>.h` | Zephyr-level config/data structs |
| `src/*_transfer.c` | Transfer function definitions |
| `samples/repl/` | Small Zephyr app to use the driver in a shell |
| `tests/unit/` | Small Zephyr app for unit-testing the library |
| `dts/bindings/` | Devicetree binding YAML for the device `compatible` string |
| `zephyr/module.yml` | Declares the west module name and CMake/Kconfig/devicetree roots |
