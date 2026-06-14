# Kconfig

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Kconfig selects which Zephyr subsystems and drivers are compiled into a build. CMake reads the resolved `.config` and includes only enabled code.

## Where PEROVSAT sets options

| File | Role |
|------|------|
| `perovsat-app/prj.conf` | Base application options |
| `snippets/*/*.conf` | Per-device options applied by dbuild (`CONFIG_PEROVSAT_IMU_MOCK=y`, etc.) |
| Driver `Kconfig` | Symbols for each out-of-tree module |

Convention: enable with `=y`, disable by commenting out (easier `#ifdef` checks).

## Interactive editing

From the app build directory:

```bash
west build -t menuconfig
```

Copy desired symbols from the generated `.config` into `prj.conf` or snippet conf files.

## Custom symbols

Driver repos define options like:

```kconfig
config PEROVSAT_IMU_MOCK
    bool "MPU6050 mock driver"
```

Official reference: [Zephyr Kconfig](https://docs.zephyrproject.org/latest/build/kconfig/index.html).
