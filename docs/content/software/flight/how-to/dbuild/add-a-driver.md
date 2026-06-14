# Add a Driver to DBuild

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Adding a device to dbuild spans two repos: the **driver module** and **perovsat-app** wiring.

## 1. Create the driver repo(s)

Clone `driver-template` and run `setup.py` for each mode you need:

```bash
git clone git@github.com:PEROVSAT/driver-template.git my-device-mock-driver
cd my-device-mock-driver
python3 setup.py --mode mock --device IMU --vendor invensense --driver mpu6050
```

Repeat with `--mode hardware` if you have a separate hardware repo (often private).

Implement the `TODO` items in the generated driver. See [Creating a Driver](../drivers/creation.md).

## 2. Register in perovsat-app

In the application repo:

1. Add west projects to `west.yml` and run `west update`.
2. Create mock and/or hardware snippets under `snippets/`.
3. Add entries to `dbuild/device_map.yml`.
4. Add a line to `dbuild_devices.conf`.

The [Add a device to dbuild](../add-device-to-dbuild.md) guide walks through snippets and `device_map.yml` in detail.

## 3. Verify

```bash
west dbuild -b nucleo_u575zi_q --dry-run
west dbuild -b nucleo_u575zi_q
```

Run driver tests before integrating: [Adding Tests](../drivers/adding-tests.md).
