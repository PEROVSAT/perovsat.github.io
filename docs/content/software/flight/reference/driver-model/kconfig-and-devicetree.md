# Kconfig and Devicetree

## Kconfig structure

Top-level `Kconfig` sources the driver-specific file:

```kconfig
rsource "src/Kconfig"
```

### Driver enable symbol

```kconfig
config PEROVSAT_MPU6050
	bool "MPU6050 driver"
	depends on DT_HAS_ZEPHYR_MPU6050_ENABLED
	depends on !MPU6050
	select I2C
```

| Field | Purpose |
|-------|---------|
| `depends on DT_HAS_*` | Driver compiles only when a matching devicetree node is present |
| `select I2C` (or other bus) | Pull in required Zephyr subsystem Kconfig |
| `depends on !MPU6050` | Avoid conflict with the in-tree Zephyr MPU6050 driver when both could apply |

DBuild snippet `.conf` files set `CONFIG_PEROVSAT_MPU6050=y` to enable the module.

### Backend choice

```kconfig
if PEROVSAT_MPU6050

choice
	prompt "MPU6050 backend"
	default PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK

config PEROVSAT_MPU6050_BACKEND_HARDWARE
	bool "Hardware (real device over bus)"

config PEROVSAT_MPU6050_BACKEND_SIMULATION
	bool "Simulation (socket to Basilisk)"

config PEROVSAT_MPU6050_BACKEND_LIBRARY_MOCK
	bool "Library mock (static register data via device library)"

config PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK
	bool "Public mock (hardcoded data, no library required)"

endchoice

endif
```

DBuild sets the active choice via `-DCONFIG_PEROVSAT_MPU6050_BACKEND_<MODE>=y`. Symbol names in `dbuild.yml` must match these exactly.

### Template token mapping

From `driver-template` `setup.py`:

| Generated symbol | Pattern |
|------------------|---------|
| Root enable | `CONFIG_PEROVSAT_<DRIVER_UPPER>` |
| Backend choice | `CONFIG_PEROVSAT_<DRIVER_UPPER>_BACKEND_<MODE>` |
| Devicetree guard | `DT_HAS_<NORMALIZED_COMPAT>_ENABLED` |

## Devicetree binding

Bindings live at `dts/bindings/<vendor>,<chip>.yaml`:

```yaml
description: MPU6050 device driver

compatible: "zephyr,mpu6050"

include: i2c-device.yaml

on-bus: i2c

properties:
  accel-fs:
    type: int
    default: 2
    enum: [2, 4, 8, 16]

  gyro-fs:
    type: int
    default: 250
    enum: [250, 500, 1000, 2000]

  smplrt-div:
    type: int
    default: 0
```

| Field | Purpose |
|-------|---------|
| `compatible` | Matched by `DT_DRV_COMPAT` in the driver `.c` file |
| `include` | Inherit standard bus properties (for example I2C address) |
| `properties` | Values exposed to C via `DT_INST_PROP(inst, …)` |

The `compatible` string in the binding must match the node in application snippet overlays.

## Config and data structs

Defined in `src/<chip>.h` and populated from devicetree at compile time.

### Config (read-only, ROM)

```c
struct mpu6050_config {
	uint8_t accel_fs;
	uint16_t gyro_fs;
	uint8_t smplrt_div;

#if defined(CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE)
	struct i2c_dt_spec bus;
#endif
};
```

Bus-specific fields (for example `struct i2c_dt_spec bus`) are included only for backends that need them. Hardware transfer code reads `config->bus`; mock backends do not require it.

### Data (mutable, RAM)

```c
struct mpu6050_data {
	int16_t accel_x, accel_y, accel_z;
	int16_t gyro_x, gyro_y, gyro_z;
	int16_t temp;
	uint16_t accel_sensitivity_shift;
	uint16_t gyro_sensitivity_x10;
	enum mpu6050_device_type device_type;
};
```

Fields used only by library backends can be wrapped in `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)`.

## Driver registration

### `DT_DRV_COMPAT`

Must match the binding `compatible`, with commas replaced by underscores:

```c
#define DT_DRV_COMPAT zephyr_mpu6050
```

### Per-instance init macro

```c
#define MPU6050_INIT(inst)                                                         \
	static struct mpu6050_data mpu6050_data_##inst;                            \
	static const struct mpu6050_config mpu6050_config_##inst = {               \
		.accel_fs = DT_INST_PROP(inst, accel_fs),                          \
		.gyro_fs = DT_INST_PROP(inst, gyro_fs),                            \
		.smplrt_div = DT_INST_PROP(inst, smplrt_div),                      \
		IF_ENABLED(CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE,                 \
			   (.bus = I2C_DT_SPEC_INST_GET(inst),)) };                  \
	SENSOR_DEVICE_DT_INST_DEFINE(inst, mpu6050_init, NULL,                       \
				     &mpu6050_data_##inst, &mpu6050_config_##inst, \
				     POST_KERNEL, 100, &mpu6050_api);

DT_INST_FOREACH_STATUS_OKAY(MPU6050_INIT)
```

| Macro | Use |
|-------|-----|
| `DEVICE_DT_INST_DEFINE` | Generic Zephyr device with a custom API struct |
| `SENSOR_DEVICE_DT_INST_DEFINE` | Sensor API driver (MPU6050) |

`POST_KERNEL` and priority `100` are the template defaults (`BOOT_STAGE`, `BOOT_PRIORITY` in the header).

See [Backends](backends.md) for backend symbol wiring and [DBuild configuration](../dbuild/configuration.md) for snippet overlay structure.
