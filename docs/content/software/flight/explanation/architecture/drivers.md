# PEROVSAT Device Drivers
For information on what drivers are, see [Zephyr Drivers](../zephyr/drivers.md)

## Custom Drivers
### Aerospace Measurement Unit
[API Reference](../../reference/drivers/amu.md)
[Repository](https://github.com/PEROVSAT/amu-driver)

Currently, our only usage of the AMUs is taking IV sweeps and corresponding temperature data. All of this is encapsulated into a single call called `do_iv_sweep`

This driver should be operated only by the payload thread

The driver depends on Aerospaces [AMULIB](https://github.com/the-aerospace-corporation/amulib/tree/main) for hardware interaction

### Nearspace Launch Eyestar S4
[API Reference](../../reference/drivers/eyestar.md)
[Repository](https://github.com/PEROVSAT/eyestar-driver)

The Eyestar S4 is our radio modem that allows us to receive commands to the satellite and send data back to Earth. The way that Iridium does communication is a little odd, so instead of individual send and receive methods, the best way to interact with the modem is a single `transfer` call, which takes buffers for both uplink and downlink data

This driver should be operated only by the communications thread

The underlying operations of the modem are under NDA, so the library handling all the hardware communication is in a separate private repository

### Nearspace Launch Electrical Power System (EPS)
[API Reference](../../reference/drivers/eps.md)

!!! note "Not implemented"
    We have not yet received an Interface Control Document (ICD) to know how we'll interact with the EPS, so we have not created this driver yet

### Inertial Measurement Unit
[API Reference](../../reference/drivers/imu.md)
[Repository](https://github.com/PEROVSAT/mpu6050-driver)

!!! note "Model TBD"
    While we have created a driver for the MPU6050 for testing purposes, the actual model of IMU to fly on PEROVSAT is unknown.

### Sun Sensor
[API Reference](../../reference/drivers/sun-sensor.md)

!!! note "Model TBD"
    The model of sun sensor to be used on PEROVSAT is unknown, as are its capabilities, so the API is not fully solidified either

