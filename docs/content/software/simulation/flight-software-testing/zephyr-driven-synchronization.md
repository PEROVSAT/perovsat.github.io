# Zephyr-Driven Simulation Synchronization

!!! info "Purpose"
    This document describes the proposed synchronization architecture between the PEROVSAT flight software running in Zephyr/QEMU and the Basilisk spacecraft simulation during Software-in-the-Loop (SITL) testing.

---

# Overview

During Software-in-the-Loop (SITL) testing, the flight software executes as if it were running on the spacecraft while Basilisk simulates the spacecraft dynamics, orbital environment, sensors, and actuators.

To produce realistic sensor data, both systems must remain synchronized in simulation time.

The proposed architecture uses **Zephyr as the simulation time master**. Rather than allowing Basilisk to advance independently, the flight software specifies the current simulation time whenever it requests information from a simulated device.

This guarantees that every sensor reading corresponds to the exact point in simulated time expected by the flight software.

---

# Design Goals

The synchronization system should satisfy the following requirements:

- Sensor data must always correspond to the requested simulation time.
- Flight software should not depend on real wall-clock time.
- Simulation results should be deterministic and reproducible.
- Simulation should support pausing, stepping, and accelerated execution.
- The same driver interface should be usable with both simulated and physical hardware.

---

# System Architecture

```text
                  Flight Software

                         │

                  Device Driver

                         │

                SITL Emulator Backend

                         │

         Sensor Request + Simulation Time

                         │

                     Basilisk

                         │

          Advance Simulation to Requested Time

                         │

             Generate Simulated Measurement

                         │

                 Return Sensor Data
```

In this architecture, the flight software controls the progression of simulation time.

---

# Synchronization Workflow

The synchronization sequence for a sensor request is:

1. The flight software determines the current simulation time.
2. The driver sends a request to the Basilisk simulation.
3. The request includes the desired simulation timestamp.
4. Basilisk advances the spacecraft simulation until the requested time is reached.
5. Basilisk computes the requested sensor measurement.
6. The simulated sensor value is returned to the flight software.

This guarantees that every measurement corresponds to the exact simulation time requested by the firmware.

---

# Example

Consider the following flight software:

```cpp
imu_read();

k_sleep(K_SECONDS(1));

imu_read();
```

Execution proceeds as follows.

### First IMU Reading

```text
Simulation Time = 0.000 s

↓

Driver requests IMU at t = 0.000

↓

Basilisk advances to 0.000 s

↓

IMU measurement returned
```

### Sleep

```text
Zephyr advances simulation time

↓

Current simulation time = 1.000 s
```

### Second IMU Reading

```text
Driver requests IMU at t = 1.000 s

↓

Basilisk advances to 1.000 s

↓

New IMU measurement returned
```

The second measurement therefore represents the spacecraft exactly one simulated second after the first.

---

# Driver Responsibilities

The SITL driver is responsible for communication between the flight software and Basilisk.

Responsibilities include:

- Tracking the current simulation time.
- Sending sensor requests with timestamps.
- Receiving simulated sensor measurements.
- Returning measurements to the flight software.
- Sending actuator commands to Basilisk.

The driver should expose the same API used by physical hardware drivers.

Example:

```cpp
readIMU();

readMagnetometer();

readGPS();

writeReactionWheelTorque();

writeMagnetorquerCommand();
```

The remainder of the flight software should not know whether these requests are handled by real hardware or by Basilisk.

---

# Basilisk Responsibilities

The Basilisk simulation is responsible for producing simulated hardware behavior.

For every incoming request, Basilisk should:

1. Read the requested simulation timestamp.
2. Advance the simulation until that timestamp.
3. Update spacecraft dynamics.
4. Update environmental models.
5. Update all simulated sensors.
6. Return the requested sensor data.

Basilisk remains responsible only for spacecraft physics and environmental modeling.

It does not execute flight software logic.

---

# Advantages

Using Zephyr as the simulation time master provides several advantages.

### Deterministic Execution

Running the same simulation twice produces identical results because every sensor reading occurs at the same simulation time.

### No Clock Drift

Because Basilisk advances only when requested, the simulation cannot gradually drift away from the flight software.

### Pause and Resume

Simulation may be paused indefinitely.

Once the next request arrives, Basilisk simply advances to the requested time.

### Accelerated Simulation

The synchronization mechanism naturally supports accelerated testing.

For example,

```text
Simulation Speed = 4×

1 second of real time

↓

4 seconds of simulation time
```

The only difference is that the timestamps supplied by Zephyr advance four times faster.

The synchronization algorithm itself does not change.

---

# Future Work

Future improvements include:

- Communication latency simulation.
- Packet loss simulation.
- Multiple simulated devices operating simultaneously.
- Hardware-in-the-Loop support.
- Time synchronization across distributed simulations.
- Configurable simulation speed multipliers.

---

# Summary

The proposed architecture makes the flight software responsible for simulation time while Basilisk remains responsible for spacecraft physics.

By synchronizing every sensor request to an explicit simulation timestamp, the flight software always receives data corresponding to the correct spacecraft state.

This architecture eliminates clock drift, provides deterministic execution, and supports both real-time and accelerated Software-in-the-Loop testing.