# Hysteresis Rod Module

> **Implementation Status:** ⚠️ **Partially Implemented**
>
> The Hysteresis Rod module is currently **not fully implemented**. While the repository includes the framework for modeling magnetic hysteresis rods and material properties, the complete nonlinear hysteresis behavior has not yet been fully integrated or validated. At its current stage, the module serves as the foundation for future development rather than a finalized flight-quality implementation.

---

# Overview

The **Hysteresis Rod** module models the passive energy dissipation provided by soft ferromagnetic rods mounted inside the spacecraft. Together with the permanent magnet, hysteresis rods form the Passive Magnetic Attitude Control (PMAC) system.

Unlike the permanent magnet, which provides a restoring torque that aligns the spacecraft with Earth's magnetic field, hysteresis rods dissipate rotational kinetic energy by continuously magnetizing and demagnetizing as the spacecraft rotates through the geomagnetic field.

This passive damping mechanism gradually reduces the spacecraft's angular velocity without requiring any electrical power or active control.

---

## Purpose

The Hysteresis Rod module is intended to:

- Model magnetic hysteresis within soft magnetic materials.
- Simulate passive detumbling of the spacecraft.
- Compute magnetic energy dissipation.
- Work together with the Permanent Magnet module to stabilize spacecraft attitude.

---

## Physical Principle

A hysteresis rod is constructed from a soft ferromagnetic material with a very high magnetic permeability.

As the spacecraft rotates through Earth's magnetic field, the magnetic field inside the rod continuously changes.

Instead of following the magnetic field instantaneously, the material exhibits **magnetic hysteresis**, producing a characteristic hysteresis loop.

The enclosed area of the hysteresis loop represents energy that is dissipated as heat during every magnetic cycle.

This continual energy loss gradually removes rotational energy from the spacecraft, reducing its tumble rate over time.

---

## Hysteresis Behavior

The relationship between magnetic field strength \(H\) and magnetic flux density \(B\) is nonlinear.

Instead of a single-valued function,

$$
B=f(H)
$$

the magnetic response depends on the previous magnetization state of the material.

This produces the familiar hysteresis loop.

```text
          B

          ^
          |
      ____/¯¯¯¯\
     /          \
    |            |
     \____    __/
          \__/

-----------------------------> H
```

The area enclosed by the loop corresponds to the energy dissipated during one magnetization cycle.

---

## Material Model

The repository includes material parameters for **HyMu-80**, a high-permeability nickel-iron alloy commonly used in passive magnetic attitude control systems.

Material properties are stored in configuration files and include parameters required by the Jiles–Atherton hysteresis model, such as:

- Saturation magnetization
- Anhysteretic magnetization constant
- Domain coupling coefficient
- Pinning coefficient
- Reversibility coefficient

These parameters define how the magnetic material responds to changing magnetic fields.

---

## Current Repository Implementation

The repository provides the infrastructure required for hysteresis rod simulation.

Implemented components include:

- Material configuration files.
- Geometry calculations.
- Rod creation factory.
- Integration with Basilisk.
- Connection to the World Magnetic Model.
- Connection to the spacecraft dynamics simulation.

The module currently computes rod geometry and loads magnetic material parameters from configuration files before attaching the rod to the simulation.

---

## Geometry Calculation

The rod factory computes the physical properties of each hysteresis rod.

The rod volume is calculated as

$$
V=\pi r^2L
$$

where

- \(r\) is the rod radius,
- \(L\) is the rod length.

The implementation also computes the rod demagnetization factor using analytical approximations for long cylindrical rods.

These geometric properties influence the magnetic response of the rod.

---

## Simulation Workflow

```text
World Magnetic Model
          │
          ▼
Magnetic Field
          │
          ▼
Read Material Parameters
          │
          ▼
Compute Rod Geometry
          │
          ▼
Hysteresis Rod Model
          │
          ▼
Magnetic Damping Torque
          │
          ▼
Spacecraft Dynamics
```

---

## Current Limitations

Although the repository contains the framework for hysteresis rod simulation, several important components remain incomplete.

The current implementation **does not yet provide a fully validated nonlinear hysteresis simulation**.

Current limitations include:

- Nonlinear hysteresis behavior is still under development.
- The complete Jiles–Atherton model has not been fully integrated into the simulation workflow.
- Magnetic saturation effects have not been fully validated.
- Experimental hardware validation has not yet been performed.
- Additional verification is required before the module can be considered flight representative.

---

## Planned Improvements

Future development of the Hysteresis Rod module will include:

- Complete implementation of the nonlinear Jiles–Atherton hysteresis equations.
- Accurate computation of magnetic damping torque.
- Validation using experimental magnetic material data.
- Support for multiple rod orientations.
- Thermal effects on magnetic properties.
- Comparison with hardware detumbling experiments.

---

## Summary

The Hysteresis Rod module provides the foundation for modeling passive magnetic damping in the PMAC system. While the repository already includes the supporting infrastructure, material configuration, and geometry calculations required for hysteresis rod simulation, the implementation is **currently incomplete**. Future work will focus on integrating and validating a full nonlinear hysteresis model to accurately represent passive spacecraft detumbling.