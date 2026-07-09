# Simulation Software

Updated: 7/9/26

PEROVSAT's simulation stack is built on **[Basilisk](https://hanspeterschaub.info/basilisk/)**, an open-source spacecraft dynamics and GNC framework from CU Boulder's AVS Lab, with **[Vizard](https://hanspeterschaub.info/basilisk/Vizard.html)** for 3D playback of results.

## Basilisk

### What it does

Basilisk simulates spacecraft motion and the subsystems that affect it. In practice that means:

- Orbital and attitude dynamics
- Environmental models (gravity, atmosphere, magnetic field, solar radiation pressure, etc.)
- Sensors, actuators, and control algorithms
- Flight-software-facing device models for SITL (see [Basilisk Flight Software Interface](basilisk-flight-software-interface.md))

Simulation components are independent modules that communicate through a publish-subscribe message system rather than sharing internal state directly. That makes it straightforward to swap, extend, or test individual pieces without rewiring the whole scenario.

### How it works

Each simulation step, Basilisk gathers forces, torques, and sensor outputs from the active modules, then advances the spacecraft state forward in time.

State propagation uses a **4th-order Runge-Kutta (RK4)** integrator. Instead of assuming constant acceleration over a timestep, RK4 evaluates the dynamics at several points within the step and combines those samples into a single update. That gives better accuracy than a simple Euler step, which matters when environmental effects and control torques change quickly across a timestep.

## Developer experience

Most day-to-day work happens in **Python simulation scenarios**: you assemble modules, wire messages, set initial conditions, and run the sim.

When stock Basilisk modules are not enough, you can write **custom C++ modules** (compiled into the Basilisk build) for new physics, sensors, or actuators. Our project-specific modules live under `ExternalModules/`. Python wrappers and small helpers (e.g. orbit setup, factory utilities) sit alongside them so scenarios stay readable.

For deeper dives on specific models we have added, see the linked pages below.

## Vizard

Vizard is Basilisk's 3D viewer. It does not run the simulation — it replays state history that Basilisk records during a run.

We use **file-based visualization** rather than Vizard's live-stream mode: Basilisk writes a `.bin` file (typically under `_VizFiles/`) while the sim runs, and you open that file in Vizard afterward. This keeps visualization decoupled from the numerical loop, which is important as we move toward full SITL runs where Basilisk must stay in sync with emulated flight software. Recording to disk avoids the overhead and timing coupling of a live render stream, and lets you replay or share results without rerunning the sim.

```text
Python scenario  →  Basilisk (integrate)  →  .bin file  →  Vizard playback
```

## Further reading

- [Basilisk Flight Software Interface](basilisk-flight-software-interface.md) — SITL device modeling and firmware integration
- [Hysteresis Rods](Hysterisis_Rods.md)
- [World Magnetic Model (WMM)](WMM.md)
- [Permanent Magnet Attitude Control (PMAC)](PMAC.md)
- [Zephyr-driven synchronization](zephyr-driven-synchronization.md)
