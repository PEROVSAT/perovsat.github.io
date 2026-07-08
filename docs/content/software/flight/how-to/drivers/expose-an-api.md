# Expose an API

If your device fits Zephyr's standard sensor channels, use the Sensor API. Otherwise define a custom function table. See [Driver Model overview](../../explanation/driver-model.md) for when each pattern applies.

## Sensor API

The MPU6050 driver is the reference implementation. See also [Zephyr Sensor API](https://docs.zephyrproject.org/latest/hardware/peripherals/sensor/index.html).

### Implement the driver API struct

```c
const struct sensor_driver_api mpu6050_api = {
	.sample_fetch = sample_fetch,
	.channel_get = channel_get,
};
```

`sample_fetch` pulls raw data into driver-private storage (or returns immediately for public mock). `channel_get` converts cached raw values into `struct sensor_value` for the requested `enum sensor_channel`.

### Register as a sensor device

```c
SENSOR_DEVICE_DT_INST_DEFINE(inst, mpu6050_init, NULL,
			     &mpu6050_data_##inst, &mpu6050_config_##inst,
			     POST_KERNEL, 100, &mpu6050_api);
```

### Application usage

```c
const struct device *imu = DEVICE_DT_GET(DT_ALIAS(imu));

sensor_sample_fetch(imu);
sensor_channel_get(imu, SENSOR_CHAN_ACCEL_XYZ, accel);
sensor_channel_get(imu, SENSOR_CHAN_GYRO_XYZ, gyro);
```

## Custom API

The Eyestar modem is the reference custom API — combined TX/RX in a single `transfer` call.

### Declare the API struct

In the driver header:

```c
struct eyestar_driver_api {
	int (*transfer)(const struct device *dev, const uint8_t *tx_buf, size_t tx_len,
			uint8_t *rx_buf, struct eyestar_transfer_result *res);
};
```

### Implement and register

```c
static int eyestar_transfer_impl(const struct device *dev, …) { … }

const struct eyestar_driver_api eyestar_api = {
	.transfer = eyestar_transfer_impl,
};

DEVICE_DT_INST_DEFINE(inst, eyestar_init, NULL,
		      &eyestar_data_##inst, &eyestar_config_##inst,
		      POST_KERNEL, 100, &eyestar_api);
```

### Provide an accessor

Application code should not cast `dev->api` directly. Provide an inline helper in a public header:

```c
static inline const struct eyestar_driver_api *eyestar_get_api(const struct device *dev)
{
	return (const struct eyestar_driver_api *)dev->api;
}
```

### Application usage

```c
const struct device *modem = DEVICE_DT_GET(DT_ALIAS(modem));
const struct eyestar_driver_api *api = eyestar_get_api(modem);

api->transfer(modem, tx_buf, tx_len, rx_buf, &result);
```

## Public mock and API shape

For `public-mock`, implement the same function signatures with hardcoded return values. MPU6050 public mock returns zero acceleration on X/Y, ~1 g on Z, and zero gyro.

## Related

- [Implement a driver](implement-a-driver.md) — where API functions are wired into `init()` and registration
- [Eyestar API reference](../../reference/drivers/eyestar.md) — custom API example (page predates current model; API shape still applies)
