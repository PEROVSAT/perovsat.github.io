# Expose a Sensor API

Updated: 7/10/26

Use Zephyr's Sensor API when the device fits standard sensor channels (accel, gyro, temp, etc.). The MPU6050 driver is the reference. See also the [Zephyr Sensor API](https://docs.zephyrproject.org/latest/hardware/peripherals/sensor/index.html).

For devices that need a custom function table instead, see [Expose a Custom API](custom-api.md).

## 1. Include the Sensor API

In `src/<chip>.h`, include the sensor header and drop the template's custom `struct <chip>_driver_api` — Sensor API drivers use `struct sensor_driver_api` from Zephyr:

```c
#include <zephyr/drivers/sensor.h>
```

Keep `struct <chip>_config` and `struct <chip>_data`. Cache raw samples in `_data` for library-backed backends (wrap those fields in `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)` if they are unused by public mock).

## 2. Implement `sample_fetch` and `channel_get`

In `src/<chip>.c`, implement both functions with a public-mock branch:

```c
#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)

static int sample_fetch(const struct device *dev, enum sensor_channel channel)
{
	struct <chip>_data *data = dev->data;

	ARG_UNUSED(channel);
	return <chip>_lib_sample_fetch(<chip>_transfer, (void *)dev, /* outputs… */);
}

static int channel_get(const struct device *dev, enum sensor_channel channel,
		       struct sensor_value *val)
{
	struct <chip>_data *data = dev->data;
	/* Convert cached raw values into struct sensor_value for the channel */
	…
}

#else /* public-mock */

static int sample_fetch(const struct device *dev, enum sensor_channel channel)
{
	ARG_UNUSED(dev);
	/* Accept the channels you support; return -ENOTSUP otherwise */
	return 0;
}

static int channel_get(const struct device *dev, enum sensor_channel channel,
		       struct sensor_value *val)
{
	ARG_UNUSED(dev);
	/* Return hardcoded sensor_value data for supported channels */
	…
}

#endif
```

`sample_fetch` pulls raw data into driver-private storage (or no-ops for public mock). `channel_get` converts cached raw values into `struct sensor_value`.

## 3. Register with `SENSOR_DEVICE_DT_INST_DEFINE`

The template defaults to `DEVICE_DT_INST_DEFINE`. Switch to the sensor macro and point at `sensor_driver_api`:

```c
const struct sensor_driver_api <chip>_api = {
	.sample_fetch = sample_fetch,
	.channel_get = channel_get,
};

#define <CHIP>_INIT(inst)                                                                          \
	static struct <chip>_data <chip>_data_##inst;                                              \
	static const struct <chip>_config <chip>_config_##inst = {                                 \
		/* DT_INST_PROP / bus fields */                                                    \
	};                                                                                         \
	SENSOR_DEVICE_DT_INST_DEFINE(inst, <chip>_init, NULL, &<chip>_data_##inst,                 \
				     &<chip>_config_##inst, BOOT_STAGE, BOOT_PRIORITY,            \
				     &<chip>_api);

DT_INST_FOREACH_STATUS_OKAY(<CHIP>_INIT)
```

## 4. Application usage

```c
const struct device *imu = DEVICE_DT_GET(DT_ALIAS(imu));

sensor_sample_fetch(imu);
sensor_channel_get(imu, SENSOR_CHAN_ACCEL_XYZ, accel);
sensor_channel_get(imu, SENSOR_CHAN_GYRO_XYZ, gyro);
```

## Related

- [Implement a driver](implement-a-driver.md)
- [Expose a Custom API](custom-api.md)
- [Driver model reference](../../reference/driver-model/index.md) — `DEVICE_DT_INST_DEFINE` vs `SENSOR_DEVICE_DT_INST_DEFINE`
