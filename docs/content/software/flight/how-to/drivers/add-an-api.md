# Add a Driver API

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Many PEROVSAT devices expose a custom C API — a struct of function pointers registered as the device's `api` field in `DEVICE_DT_INST_DEFINE`.

## Pattern

1. Declare an API struct in the driver header:

```c
struct my_driver_api {
    int (*read_sample)(const struct device *dev, struct sample *out);
};
```

2. Implement functions and a static `const struct my_driver_api driver_api = { ... };`

3. Pass `&driver_api` as the last argument to `DEVICE_DT_INST_DEFINE`.

4. Provide an accessor for application code:

```c
static inline const struct my_driver_api *my_driver_api(const struct device *dev)
{
    return (const struct my_driver_api *)dev->api;
}
```

## Sensor drivers

If the device fits Zephyr's [Sensor API](https://docs.zephyrproject.org/latest/hardware/peripherals/sensor/index.html), implement `struct sensor_driver_api` instead of a fully custom table. The Payload thread is expected to use the Sensor API where possible.

## Open questions

- Whether all mission drivers will share a PEROVSAT-specific API header or only use Zephyr stock APIs.
