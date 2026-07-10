# Expose a Custom API

Updated: 7/10/26

Use a custom API when the device does not fit Zephyr's standard Sensor channels (modems, actuators, mission-specific peripherals). The template scaffolds this path by default with `struct <chip>_driver_api` and `DEVICE_DT_INST_DEFINE`.

For sensors that map to Zephyr channels, see [Expose a Sensor API](sensor-api.md).

## 1. Declare the API struct

In `src/<chip>.h`, fill in the template's API struct with the function pointers application code will call:

```c
struct <chip>_driver_api {
	int (*read_sensor)(const struct device *dev, uint8_t *val);
	/* additional operations… */
};
```

## 2. Implement with a public-mock branch

In `src/<chip>.c`, implement each function. Library-backed backends call into `lib/`; public mock returns hardcoded data:

```c
static int read_sensor(const struct device *dev, uint8_t *val)
{
#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)
	return <chip>_lib_read_sensor(<chip>_transfer, (void *)dev, val);
#else
	ARG_UNUSED(dev);
	*val = 0x01;
	return 0;
#endif
}

const struct <chip>_driver_api <chip>_api = {
	.read_sensor = read_sensor,
};
```

The template's `init()` already calls `transfer_init` then `lib_init` for non–public-mock backends, and returns `0` for public mock. Leave that wiring alone unless your library needs extra arguments.

## 3. Register with `DEVICE_DT_INST_DEFINE`

The template already uses this macro. Confirm the API pointer is passed through:

```c
DEVICE_DT_INST_DEFINE(inst, <chip>_init, NULL, &<chip>_data_##inst,
		      &<chip>_config_##inst, BOOT_STAGE, BOOT_PRIORITY,
		      &<chip>_api);
```

## 4. Provide an accessor

Application code should not cast `dev->api` directly. Add an inline helper in the public header:

```c
static inline const struct <chip>_driver_api *<chip>_get_api(const struct device *dev)
{
	return (const struct <chip>_driver_api *)dev->api;
}
```

## 5. Application usage

```c
const struct device *dev = DEVICE_DT_GET(DT_ALIAS(my_device));
const struct <chip>_driver_api *api = <chip>_get_api(dev);

api->read_sensor(dev, &val);
```

## Thin-driver alternative

For very thin drivers, you can skip the API struct and expose ordinary public functions that take `const struct device *` (Eyestar does this and passes `NULL` as the API pointer to `DEVICE_DT_INST_DEFINE`). Prefer the struct pattern above unless the surface is a single call with no need for polymorphism.

## Related

- [Implement a driver](implement-a-driver.md)
- [Expose a Sensor API](sensor-api.md)
- [Driver model reference](../../reference/driver-model/index.md)
