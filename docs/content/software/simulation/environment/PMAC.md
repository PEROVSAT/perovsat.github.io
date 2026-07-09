# Permanent Magnet Module

Updated: 7/9/26

## Overview

The **Permanent Magnet** module models the restoring torque from a fixed magnetic dipole in Earth's field. It is the primary alignment element of Passive Magnetic Attitude Control (PMAC), working alongside [hysteresis rods](Hysterisis_Rods.md) that provide damping. The magnet needs no power, sensors, or control logic — it simply applies torque as the spacecraft tumbles.

Each simulation step, the module reads \(\mathbf{B}\) from the [WMM](WMM.md), rotates it into the body frame using the current attitude, computes \(\boldsymbol{\tau} = \mathbf{m} \times \mathbf{B}\), and applies that torque to the spacecraft dynamics.

## Basilisk implementation

The module is a custom `DynamicEffector` in `ExternalModules/permanentMagnet/`. The dipole moment \(\mathbf{m}_B\) is set in Python via `magDipole_B` (body frame, A·m²). It subscribes to the WMM magnetic field message and publishes the computed torque for logging and visualization.

Torque is evaluated inside `computeForceTorque` at integrator sub-steps, using the continuous attitude state from the hub MRPs rather than the discrete post-step value. That keeps the restoring torque consistent with the dynamics solver throughout each RK4 step.

## Math Guide

A magnetic dipole in an external field experiences torque:

$$
\boldsymbol{\tau} = \mathbf{m} \times \mathbf{B}
$$

The WMM provides the field in the inertial frame \(\mathbf{B}_N\). The spacecraft attitude (MRPs) maps to a direction cosine matrix \([BN]\) that rotates into the body frame:

$$
\mathbf{B}_B = [BN]\,\mathbf{B}_N
$$

The applied body-frame torque is then:

$$
\boldsymbol{\tau}_B = \mathbf{m}_B \times \mathbf{B}_B
$$

where \(\mathbf{m}_B\) is the fixed dipole vector in body coordinates. Basilisk collects \(\boldsymbol{\tau}_B\) through the `DynamicEffector` interface and integrates it into the spacecraft equations of motion.
