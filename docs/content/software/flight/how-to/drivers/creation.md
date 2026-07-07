# Creating a Driver

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

New PEROVSAT drivers start from the [`driver-template`](https://github.com/PEROVSAT/driver-template) repository.

## Quick start

```bash
git clone git@github.com:PEROVSAT/driver-template.git my-driver
cd my-driver
python3 setup.py
```

Interactive prompts cover mode (`hardware` or `mock`), logical device name, vendor compatible prefix, driver slug, subsystem, and west module name.

Non-interactive example:

```bash
python3 setup.py --mode mock --device IMU --vendor invensense --driver mpu6050
```

After setup, `template/` and `setup.py` are removed. The repo is a standalone Zephyr module with driver source, devicetree binding, Kconfig, and test scaffolds.

## What to implement

Work through the generated README checklist:

1. Devicetree binding properties
2. Config/data structs and `init()`
3. Per-instance `DEVICE_DT_INST_DEFINE` registration
4. Driver API (if exposing functions beyond stock Zephyr APIs)

Reference implementation: `mpu6050-mock-driver` in the workspace.

## Next steps

- Wire into `perovsat-app` via [Add a device to DBuild](../dbuild/add-device.md)
- Add [tests](adding-tests.md) as you implement behavior
