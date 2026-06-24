# PEROVSAT Device Drivers
For information on what drivers are, see [Zephyr Drivers](../zephyr/drivers.md)

## PEROVSAT Driver Model
### Driver-Library Separation
PEROVSAT drivers have all the Zephyr-specific driver setup completely separated from the hardware specifics, which instead go in a library. This allows the flight software to do a few unique things:
- Expose a working driver while making a library private for NDA compliance
- Hardware code can be entirely stateless
- Hardware code is highly testable

### Backend Swapping
PEROVSAT Implements a unique quad-backend model for drivers.

At the top level, drivers choose to use static data (public-mock) or the use the library. If it is using the library, then it can pass it a variety of transfer functions.

For example, an IMU driver's library may have the logic to know that its gyro_x value is at register 0x3B. It tells the transfer function that it was given that it wants to access register 0x3B, and depending on what mode it is in that transfer function can access either a static value, or actually give that to Zephyr's `i2c_read` function to interact with hardware.

Most importantly, from the library's perspective, it makes no difference what backend is actually in use, it simply calls the transfer function it was given.

### Backend Modes
- Public Mock
    - Returns static data straight from the Zephyr Driver API functions, no use of the library
    - Enables rapid development; application code can interact with driver before we even know how the device hardware works
- Library Mock
    - Transfer function: Get from static register map
    - Easiest way to test a library without needing hardware
- Simulation
    - Transfer function: Send to a socket, which can communicate with other software to produce simulated data
- Hardware
    - Transfer function: Zephyr's communication API calls, like `i2c_read`
    - Actual deployment of the flight software uses this mode

Users can switch between these modes using the [DBuild configuration](../../reference/dbuild/index.md)

## Driver List
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

