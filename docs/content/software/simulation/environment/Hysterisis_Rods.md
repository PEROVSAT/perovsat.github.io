# Hysteresis Rod Module

Updated: 7/9/26

!!! warning "Validation in progress"
    The Jiles–Atherton model is implemented and integrated into Basilisk, but hardware validation and parameter tuning are still ongoing.

Hysteresis rods are soft ferromagnetic cylinders mounted along chosen body axes. As the spacecraft tumbles through Earth's magnetic field, the rod material magnetizes and demagnetizes along a **hysteresis loop** rather than tracking the field instantaneously. The area enclosed by that loop is energy lost as heat each cycle, which dissipates rotational kinetic energy and passively detumbles the spacecraft. Together with the [permanent magnet](PMAC.md), the rods form the Passive Magnetic Attitude Control (PMAC) system: the magnet provides restoring torque toward field alignment, while the rods provide damping.

Our Basilisk module models each rod with the **Jiles–Atherton (JA)** constitutive law, driven by the geomagnetic field from the [WMM](WMM.md). Material parameters for HyMu-80 are loaded from JSON configs in `hysteresis_configs/`.


## **Math Guide**

This section outlines the mathematical progression implemented in the module, moving from spacecraft kinematics to the Jiles-Atherton ODE, and finally to the resulting magnetic torque.

### **1\. Field Kinematics**

The module first determines the axial magnetic field strength $H$ and its rate of change $\\dot{H}$ along the rod's unit direction $\\hat{u}$ in the body frame.  
The inertial magnetic field $B\_N$ is rotated into the spacecraft body frame using the direction cosine matrix $\[BN\]$:

!!! note
    We are currently working on a continuous version of the WMM that does this more accurately. See [Continuous WMM Module](./WMM.md) for details

$$B\_B \= \[BN\]B\_N$$  
Applying the transport theorem using the spacecraft's body angular velocity $\\omega\_{B/N}$, the rate of change of the magnetic flux density in the body frame is:

$$\\dot{B}\_B \= \[BN\]\\dot{B}\_N \- \\omega\_{B/N} \\times B\_B$$  
*(Note: $\\dot{B}\_N$ is computed via a finite difference of the discrete magnetometer updates.)*  
Using the vacuum permeability $\\mu\_0$, these vectors are projected onto the rod's orientation $\\hat{u}$ to find the scalar field strength and its time derivative:

$$H \= \\frac{B\_B \\cdot \\hat{u}}{\\mu\_0}$$

$$\\dot{H} \= \\frac{\\dot{B}\_B \\cdot \\hat{u}}{\\mu\_0}$$

### **2\. Jiles-Atherton Magnetization ODE**

The core of the module computes the rate of change of magnetization $\\frac{dM}{dt}$ using a modified Jiles-Atherton model that accounts for demagnetization.  
First, the effective field $H\_e$ experienced by the domain walls is calculated, incorporating both the interdomain coupling $\\alpha$ and the demagnetizing factor $N\_d$:

$$H\_e \= H \+ (\\alpha \- N\_d)M$$  
The anhysteretic magnetization $M\_{an}$ (the ideal, lossless magnetization curve) is modeled using the Langevin function, scaled by the saturation magnetization $M\_s$ and the shape parameter $a$. Let $x \= \\frac{H\_e}{a}$:

$$M\_{an} \= M\_s \\left( \\coth(x) \- \\frac{1}{x} \\right)$$

$$\\frac{dM\_{an}}{dH\_e} \= \\frac{M\_s}{a} \\left( 1 \- \\coth^2(x) \+ \\frac{1}{x^2} \\right)$$  
*(For numerical stability near $H\_e \= 0$, the module utilizes a small-argument expansion: $M\_{an} \\approx M\_s \\frac{x}{3}$ and $\\frac{dM\_{an}}{dH\_e} \\approx \\frac{M\_s}{3a}$).*  
To handle the irreversible domain wall pinning, the direction of the changing field is approximated smoothly to prevent ODE solver stalling:

$$\\delta \\approx \\tanh\\left(\\frac{\\dot{H}}{\\delta\_{smooth}}\\right)$$  
The irreversible differential susceptibility $\\chi\_{irr}$ dictates how magnetization lags behind the anhysteretic curve. It is strictly evaluated to prevent non-physical "pushing" of the magnetization against the field direction. If $\\delta(M\_{an} \- M) \\le 0$, then $\\chi\_{irr} \= 0$. Otherwise:

$$\\chi\_{irr} \= \\frac{M\_{an} \- M}{k\\delta \- (\\alpha \- N\_d)(M\_{an} \- M)}$$  
Where $k$ is the pinning parameter.  
The total magnetic susceptibility $\\frac{dM}{dH}$ linearly combines the reversible and irreversible components using the reversibility parameter $c$. Letting $K \= (1-c)\\chi\_{irr} \+ c \\frac{dM\_{an}}{dH\_e}$:

$$\\frac{dM}{dH} \= \\frac{K}{1 \- (\\alpha \- N\_d)K}$$  
Finally, the state derivative passed to the integrator is computed using the chain rule:

$$\\frac{dM}{dt} \= \\frac{dM}{dH}\\dot{H}$$

### **3\. Magnetic Torque**

Once the magnetization $M$ is integrated, the rod's magnetic dipole moment vector $m\_{rod}$ in the body frame is found using the rod's volume $V$:

$$m\_{rod} \= (MV)\\hat{u}$$  
The resulting mechanical torque $\\tau\_B$ exerted on the spacecraft body by the rod's interaction with the external magnetic field is:

$$\\tau\_B \= m\_{rod} \\times B\_B$$
