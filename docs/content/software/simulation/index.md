# Simulation Software

## Overview

The simulation framework is built using **Basilisk**, an open-source astrodynamics simulation environment, together with **Vizard**, a real-time 3D visualization tool. These two software packages provide the foundation for developing, testing, and visualizing spacecraft simulations.

Basilisk is responsible for the numerical simulation of spacecraft dynamics, environmental models, sensors, actuators, and control systems, while Vizard provides an interactive visualization of the simulated spacecraft and its environment.

Together, they form a complete simulation environment suitable for spacecraft research, education, mission design, and guidance, navigation, and control (GNC) development.

---

# Basilisk

## Introduction

Basilisk is an open-source astrodynamics simulation framework developed by the **Autonomous Vehicle Systems (AVS) Laboratory** at the **University of Colorado Boulder**. It is designed to provide a flexible and modular environment for spacecraft simulation and algorithm development.

The framework supports high-fidelity modeling of spacecraft translational and rotational dynamics, orbital mechanics, environmental disturbances, onboard sensors, actuators, and flight software.

Its modular architecture allows users to develop custom simulation components while reusing existing models provided by Basilisk.

---

## Features

Basilisk provides a wide range of spacecraft simulation capabilities, including:

- Orbital mechanics and propagation
- Spacecraft attitude dynamics
- Gravity models
- Atmospheric drag
- Solar radiation pressure
- Magnetic field models
- Sensor simulation
- Actuator models
- Guidance, Navigation and Control (GNC)
- Flight software simulation
- Monte Carlo analysis
- Data logging and visualization support

---

## Modular Architecture

One of Basilisk's primary strengths is its modular architecture.

Each subsystem is implemented as an independent simulation module that communicates with other modules through a message-passing interface.

```text
Simulation

│

├── Dynamics Modules

├── Environment Modules

├── Sensor Models

├── Actuator Models

├── Flight Software

├── Navigation Modules

└── Logging Modules
```

This architecture enables developers to add, remove, or replace simulation components without affecting the rest of the simulation.

---

## Message-Based Communication

Instead of allowing modules to directly access one another, Basilisk uses a message-passing architecture.

Each module publishes its outputs as messages that can be subscribed to by other modules.

```text
Module A
     │
Publishes Message
     │
     ▼
Message Bus
     │
     ▼
Module B
```

This approach improves modularity, simplifies testing, and allows components to be reused across multiple simulations.

---

## Numerical Simulation

Basilisk propagates the spacecraft state by numerically integrating the equations of motion throughout the simulation.

The framework simultaneously models:

- Translational motion
- Rotational motion
- Environmental effects
- External forces
- External torques
- Control system interactions

The simulation advances using a user-defined timestep while continuously updating all subscribed modules.

---

## Extensibility

Basilisk is designed to be easily extended.

Users can:

- Develop custom C++ simulation modules.
- Create Python-based simulation scripts.
- Add new environmental models.
- Implement custom sensors and actuators.
- Develop and test new spacecraft control algorithms.

This flexibility makes Basilisk suitable for both academic research and spacecraft mission development.

---

# Vizard

## Introduction

Vizard is Basilisk's real-time visualization environment. It provides a three-dimensional representation of the spacecraft and simulation environment while the numerical simulation is running.

Rather than performing physical calculations, Vizard receives simulation data from Basilisk and renders the spacecraft motion, orientation, and surrounding environment.

---

## Features

Vizard provides visualization of:

- Spacecraft attitude
- Orbital trajectory
- Planetary bodies
- Coordinate frames
- Sensor fields of view
- Thruster firings
- External force vectors
- Simulation time
- Spacecraft telemetry

---

## Visualization Pipeline

The communication between Basilisk and Vizard follows a simple workflow.

```text
Simulation

        │

        ▼

Spacecraft State

(Position, Velocity, Attitude)

        │

        ▼

Visualization Interface

        │

        ▼

Vizard

        │

        ▼

Real-Time 3D Rendering
```

As the spacecraft state changes during simulation, Vizard continuously updates the visualization in real time.

---

## Advantages of Visualization

Visualization provides several important benefits during spacecraft simulation:

- Verification of simulation behavior.
- Improved debugging.
- Easier interpretation of spacecraft motion.
- Better understanding of attitude dynamics.
- High-quality demonstrations for presentations and outreach.

---

# Basilisk–Vizard Workflow

The complete simulation workflow is illustrated below.

```text
Simulation Script
        │
        ▼
Initialize Simulation
        │
        ▼
Create Spacecraft
        │
        ▼
Add Environment Models
        │
        ▼
Add Sensors & Actuators
        │
        ▼
Run Numerical Simulation
        │
        ▼
Generate Spacecraft State
        │
        ▼
Visualization Interface
        │
        ▼
Vizard
        │
        ▼
Real-Time 3D Visualization
```

---

# Why This Software Stack?

The combination of Basilisk and Vizard provides a powerful platform for spacecraft simulation because it offers:

- Open-source development
- Modular architecture
- High-fidelity spacecraft dynamics
- Flexible software integration
- Real-time visualization
- Cross-platform compatibility
- Strong support for research and education

---

# Summary

Basilisk and Vizard together provide a complete spacecraft simulation environment. Basilisk serves as the core simulation engine, responsible for modeling spacecraft dynamics, environmental interactions, sensors, actuators, and flight software, while Vizard provides an interactive three-dimensional visualization of the simulation results. Their modular architecture and extensibility make them well suited for spacecraft research, mission design, algorithm development, and educational applications.