# World Magnetic Model (WMM)

Updated: 7/9/26

!!! warning "Not implemented"
    Simulations currently use Basilisk's stock `magneticFieldWMM` module. The continuous replacement described here is under development and not yet integrated.

The **World Magnetic Model** is the standard model of Earth's main magnetic field, published by NCEI and BGS. It describes how the field varies with position (latitude, longitude, altitude) and slowly over time, using spherical harmonic coefficients fit to satellite and ground measurements. In our PMAC simulations, the WMM is the environmental input: it provides \(\mathbf{B}\) at the spacecraft's location, which the [permanent magnet](PMAC.md) and [hysteresis rods](Hysterisis_Rods.md) modules use to compute passive magnetic torques.

## Why a continuous module?

Basilisk's built-in WMM evaluates the field once per simulation task step and holds it constant between updates — a zero-order hold. That is fine for modules that only need \(\mathbf{B}\), but the [hysteresis rod](Hysterisis_Rods.md) model is driven by the rate of change of the field along the rod axis (\(\dot{H}\)). With a discrete field, the only option is to finite-difference between steps, which produces spikes at each update followed by zeros. That is a poor approximation of a smooth physical signal and makes the stiff Jiles–Atherton ODE harder to integrate reliably.

The WMM itself is built from smooth, differentiable functions — there is nothing inherently discrete about the physics. A continuous module would evaluate \(\mathbf{B}\) and its material derivative \(\dot{\mathbf{B}} = (\mathbf{v} \cdot \nabla)\mathbf{B}\) analytically from the spacecraft's position and velocity, giving the hysteresis model a clean field rate without guessing from sampled data. The goal is more stable integration, larger usable timesteps, and results that do not depend on how coarsely the field is sampled.

Work on this module lives in `ExternalModules/magneticFieldWMMContinuous/` in the [basilisk-simulation](https://github.com/PEROVSAT/basilisk-simulation) repo.
