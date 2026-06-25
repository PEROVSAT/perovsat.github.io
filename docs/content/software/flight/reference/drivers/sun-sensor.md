# Sun Sensor Driver Reference
## Design
Sun Sensors work well in integrating with Zephyr's Sensor API, which is just a standardized set of driver API functions. The only aspect that really needs to be custom is that there is not a Sensor Channel for sun angles, so we need to have a custom one.

## Internals
### Custom Sensor Channels
```c
enum my_sensor_channel {
    SENSOR_CHAN_SUN_ANGLE_XY = SENSOR_CHAN_PRIV_START,
};
```
Though not custom, we may also be using SENSOR_CHAN_LUX if supported on our sun sensor


## API
`const struct device *dev` is an implied parameter for all but the initialization function

### int init_sun_sensor()
#### Description
Any required hardware or communication bus initialization goes here
#### Parameters
TODO: Identify configuration parameters
#### Return
An integer status code

| Code | Status Category | Description |
| --- | --- | --- |
| 0 | Success | Initialzed successfully |
| -EIO | Error | Communication Error |
| -ENODEV| Error | Could not find device |
| -1 | Error | Additional Errors TBD |


### int sample_fetch(enum sensor_channel channel)
#### Description
Pulls sun sensor data from hardware into driver's SRAM
#### Parameters
`enum sensor_channel channel` - Which of the custom sensor channels to read
#### Return
An integer status code

| Code | Status Category | Description |
| --- | --- | --- |
| 0 | Success | Initialzed successfully |
| -ENOTSUP | Error | Sensor channel requested is not supported |
| -1 | Error | Additional Errors TBD |


### int channel_get(enum sensor_channel channel, struct sensor_value *val)
#### Description
Formats the hardware data (in driver SRAM from `sample_fetch`) into the sensor_value format for specified channel
#### Parameters
`enum sensor_channel channel` - Which of the custom sensor channels to write to *val

`struct sensor_value *val` - Memory pointer to load requested value into
#### Return
An integer status code

| Code | Status Category | Description |
| --- | --- | --- |
| 0 | Success | Initialzed successfully |
| -ENOTSUP | Error | Sensor channel requested is not supported |
| -1 | Error | Additional Errors TBD |
