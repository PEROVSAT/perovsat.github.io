# Hysteresis Rod Module

Updated: 7/9/26

!!! warning "Validation in progress"
    The Jiles–Atherton model is implemented and integrated into Basilisk, but hardware validation and parameter tuning are still ongoing.

Hysteresis rods are soft ferromagnetic cylinders mounted along chosen body axes. As the spacecraft tumbles through Earth's magnetic field, the rod material magnetizes and demagnetizes along a **hysteresis loop** rather than tracking the field instantaneously. The area enclosed by that loop is energy lost as heat each cycle, which dissipates rotational kinetic energy and passively detumbles the spacecraft. Together with the [permanent magnet](PMAC.md), the rods form the Passive Magnetic Attitude Control (PMAC) system: the magnet provides restoring torque toward field alignment, while the rods provide damping.

Our Basilisk module models each rod with the **Jiles–Atherton (JA)** constitutive law, driven by the geomagnetic field from the [WMM](WMM.md). Material parameters for HyMu-80 are loaded from JSON configs in `hysteresis_configs/`.


## Math Guide

This section outlines the mathematical progression implemented in the module, moving from spacecraft kinematics to the Jiles–Atherton ODE, and finally to the resulting magnetic torque.

### Field kinematics

The module determines the axial magnetic field strength \(H\) and its rate of change \(\dot{H}\) along the rod's unit direction \(\hat{\mathbf{u}}\) in the body frame. The inertial magnetic field \(\mathbf{B}_N\) is rotated into the spacecraft body frame using the direction cosine matrix \([BN]\):

!!! note
    We are currently working on a continuous version of the WMM that does this more accurately. See [Continuous WMM Module](WMM.md) for details.

$$
\mathbf{B}_B = [BN]\,\mathbf{B}_N
$$

Applying the transport theorem with the spacecraft's body angular velocity \(\boldsymbol{\omega}_{B/N}\), the rate of change of the magnetic flux density in the body frame is:

$$
\dot{\mathbf{B}}_B = [BN]\,\dot{\mathbf{B}}_N - \boldsymbol{\omega}_{B/N} \times \mathbf{B}_B
$$

\(\dot{\mathbf{B}}_N\) is computed via a finite difference of the discrete magnetometer updates. Projecting onto the rod orientation with vacuum permeability \(\mu_0\):

$$
H = \frac{\mathbf{B}_B \cdot \hat{\mathbf{u}}}{\mu_0}, \qquad
\dot{H} = \frac{\dot{\mathbf{B}}_B \cdot \hat{\mathbf{u}}}{\mu_0}
$$

### Jiles–Atherton magnetization ODE

The module computes \(\frac{dM}{dt}\) using a modified Jiles–Atherton model that accounts for demagnetization. The effective field \(H_e\) incorporates interdomain coupling \(\alpha\) and the demagnetizing factor \(N_d\):

$$
H_e = H + (\alpha - N_d)\,M
$$

The anhysteretic magnetization follows the Langevin function. Let \(x = H_e / a\):

$$
M_{an} = M_s\left(\coth(x) - \frac{1}{x}\right)
$$

$$
\frac{dM_{an}}{dH_e} = \frac{M_s}{a}\left(1 - \coth^2(x) + \frac{1}{x^2}\right)
$$

Near \(H_e = 0\), the module uses the small-argument expansion \(M_{an} \approx M_s x / 3\) and \(dM_{an}/dH_e \approx M_s / (3a)\).

The field-rate sign is smoothed to prevent ODE solver stalling:

$$
\delta \approx \tanh\!\left(\frac{\dot{H}}{\delta_{\mathrm{smooth}}}\right)
$$

The irreversible susceptibility \(\chi_{irr}\) is zero when \(\delta\,(M_{an} - M) \le 0\); otherwise:

$$
\chi_{irr} = \frac{M_{an} - M}{k\,\delta - (\alpha - N_d)(M_{an} - M)}
$$

The total susceptibility blends reversible and irreversible contributions. Let \(K = (1-c)\,\chi_{irr} + c\,\frac{dM_{an}}{dH_e}\):

$$
\frac{dM}{dH} = \frac{K}{1 - (\alpha - N_d)\,K}
$$

The state derivative passed to the integrator is:

$$
\frac{dM}{dt} = \frac{dM}{dH}\,\dot{H}
$$

### Magnetic torque

The rod's dipole moment and the resulting body-frame torque are:

$$
\mathbf{m}_{rod} = M\,V\,\hat{\mathbf{u}}
$$

$$
\boldsymbol{\tau}_B = \mathbf{m}_{rod} \times \mathbf{B}_B
$$

