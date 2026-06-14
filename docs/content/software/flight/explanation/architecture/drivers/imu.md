# IMU Driver

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The IMU driver provides motion and orientation data to the Payload thread via the Sensor API. PEROVSAT currently uses an MPU6050-class device as the reference implementation.

## Build modes

Through dbuild, the IMU can be built as:

- **mock** — synthetic data from a mock driver repo (e.g. `mpu6050-mock-driver`)
- **hardware** — real I2C device with board-specific overlays
- **emulation** — hardware driver with I2C emulator backend for integration / SITL tests

See [Add a device to dbuild](../../../how-to/add-device-to-dbuild.md) and the `IMU` entry in `device_map.yml` for the current wiring.

## Devicetree

Application code resolves the device through a stable alias (for example `imu`) so snippets can swap the underlying compatible string without changing C code.
