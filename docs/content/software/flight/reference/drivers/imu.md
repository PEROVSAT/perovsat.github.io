# Sun Sensor Driver Reference
## Design
IMUs work perfectly with Zephyr's Sensor API, and there are existing channels for the values. It is worth noting that there are likely existing drivers for the IMUs we want to purchase, but that would prevent us from using them in simulations. Thus, we are still likely making a custom driver.

## Internals
### Sensor Channels
We will be using the `SENSOR_CHAN_ACCEL_XYZ` and `SENSOR_CHAN_GYRO_XYZ`

## API
`const struct device *dev` is an implied parameter for all but the initialization function

### int init_imu()
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
Pulls accel and/or gyro data from hardware into driver's SRAM
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
