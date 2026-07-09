# Basilisk Flight Software Interface

This document describes how Basilisk communicates with PEROVSAT flight software during Software-in-the-Loop (SITL) simulation and how new simulated devices should be implemented.

!!! info "Purpose"
    The goal is for the flight software to communicate with simulated devices exactly as it would with physical hardware. This allows the same application code and drivers to execute in simulation before hardware is available.

---

## Overview

PEROVSAT separates simulation from flight software.

- **Basilisk** models spacecraft dynamics, sensors, actuators, and the orbital environment.
- **Flight Software (FSW)** executes the real firmware using SITL emulator drivers.
- **Driver emulation backends** connect the firmware to Basilisk through a communication interface.

The firmware should not need to know whether it is communicating with a real device or a simulated one.

```text
                     Flight Software

                            │

                     Device Driver API

                            │

              SITL Emulator Backend (*_emul.c)

                            │

                 Socket / Transport Layer

                            │

                     Basilisk Module

                            │

                 Basilisk Message System

                            │

                  Spacecraft Simulation
```

---

# How Basilisk Models a Simulated Device

Every simulated hardware component is implemented as a Basilisk module.

Examples include

- IMU
- Magnetometer
- GPS
- Sun Sensor
- Reaction Wheels
- Magnetorquers
- PMAC
- Electrical Power System

Each module executes once every simulation timestep.

A typical execution cycle is

```text
Read simulation messages

↓

Perform physics calculations

↓

Generate simulated sensor or actuator behavior

↓

Publish output messages
```

The module never directly accesses another module's internal variables. All communication occurs through Basilisk's message system.

---

# Basilisk Message Flow

Basilisk uses a publish/subscribe architecture.

Modules either

- publish messages,
- subscribe to messages,
- or perform both operations.

Example

```text
Spacecraft Dynamics

↓

SCStatesMsg

↓

Magnetometer Module

↓

MagneticFieldMsg

↓

PMAC Module

↓

CmdTorqueBodyMsg

↓

ExtForceTorque

↓

Spacecraft Dynamics
```

This architecture allows modules to remain independent and reusable.

---

# Enabling Data Transfer

Communication between Basilisk and the flight software requires two independent components.

## Basilisk Module

The Basilisk module represents the simulated hardware.

Its responsibilities are

- subscribe to simulation messages
- obtain spacecraft state
- perform device-specific physics calculations
- publish simulated sensor outputs
- receive actuator commands when applicable

The module should behave identically to the physical hardware from the perspective of the flight software.

---

## Flight Software Driver

The driver provides the interface used by flight software.

Its responsibilities are

- initialize the communication interface
- request information from the simulated device
- convert received packets into driver data structures
- transmit actuator commands back to Basilisk

The remainder of the flight software should never communicate directly with Basilisk.

Instead it interacts only with the driver API.

---

# Requesting Information from a Simulated Device

The driver should expose the same functions used by the hardware implementation.

Typical examples include

```cpp
readAccelerometer();

readGyroscope();

readMagnetometer();

readGPS();

readTemperature();

readVoltage();
```

Internally these functions obtain data from Basilisk rather than physical hardware.

Because the API remains unchanged, higher-level flight software does not require modification when switching between simulation and flight hardware.

---

# Sending Commands to Simulated Hardware

Actuator drivers operate in the opposite direction.

Typical commands include

```cpp
setReactionWheelTorque();

setMagnetorquerDipole();

enableCamera();

transmitRadioPacket();
```

The emulator backend converts these requests into messages sent to Basilisk.

The corresponding Basilisk module receives the command and updates the spacecraft dynamics.

---

# How Basilisk Obtains Simulation State

Simulation state is provided by Basilisk's internal message system.

Common state information includes

| Simulation State | Example Information |
|------------------|---------------------|
| Spacecraft State | Position, velocity, attitude, angular velocity |
| Environment | Gravity, magnetic field, atmospheric density |
| Sensors | IMU, GPS, magnetometer outputs |
| Actuators | Reaction wheel torque, magnetorquer commands |

Modules subscribe only to the messages they require.

This minimizes coupling between simulation components.

---

# Example: PMAC Module

The Passive Magnetic Attitude Control (PMAC) module demonstrates the standard Basilisk workflow.

```text
SCStatesMsg

↓

Read spacecraft attitude

↓

World Magnetic Model

↓

Earth magnetic field

↓

Compute

τ = m × B

↓

CmdTorqueBodyMsg

↓

ExtForceTorque

↓

Spacecraft Dynamics
```

The PMAC module does not directly modify spacecraft variables.

Instead it publishes a torque command which is consumed by the dynamics simulation.

This message-based approach is consistent with other Basilisk modules.

---

# Driver Responsibilities

A driver should

- hide all simulator-specific communication
- provide the same API as flight hardware
- serialize requests
- deserialize responses
- perform error checking
- report communication failures

The driver should **not** contain simulation physics.

---

# Basilisk Module Responsibilities

A Basilisk module should

- model hardware behavior
- subscribe to simulation messages
- generate simulated measurements
- publish actuator responses
- inject realistic noise and latency where appropriate

The Basilisk module should **not** contain flight software logic.

---

# Future Work

Future simulation work includes

- Implement the transport layer between Basilisk and the SITL emulator backend.
- Add communication latency and packet loss models.
- Support Hardware-in-the-Loop (HIL) testing.
- Add additional sensor and actuator models.
- Expand environmental modeling for eclipse, atmospheric drag, and power generation.
