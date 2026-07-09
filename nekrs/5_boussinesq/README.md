# Buoyancy: Boussinesq Approximation

Like case 4, this case builds on `step3_temperature`, using the same heated wall patch, but instead of increasing the Reynolds number the temperature of the heated patch is increased and the effect of buoyancy is added through the Boussinesq approximation.

A custom kernel is added to the `.oudf` file, which calculates the buoyancy contribution to the volumetric force. This is used in the `.udf` file, adding a `userSource` function which is set as the `nrs->userSource` volumetric source term in `UDF_Setup`, with the nondimensional gravitational acceleration also defined in `UDF_Setup`.

## Boussinesq approximation & nondimensionalisation


A Buoyancy force can be applied, using the Boussinesq approximation, as a volumetric body force added to the momentum equation.

```math
\vec{f}_g = \rho \vec{g} \approx \rho_0 \beta (T-T_0)\vec{g}
```

where $\vec{g}$ is the acceleration due to gravity, $\beta$ is the thermal expansion coefficient, $T$ is temperature and $\rho_0$ is the density at $T=T_0$.

These variables are nondimensionalised as

```math
\vec{f_g}^\dagger = \frac{\vec{f_g}}{f_s},\quad \beta^\dagger = \frac{\beta}{\beta_s}, \quad T^\dagger = \frac{T-T_0}{\Delta T}, \quad \vec{g}^\dagger = \frac{\vec{g}}{g_s}
```

The scaling factor for the volumetric force has already been chosen as
```math
f_s=\frac{\rho_0 U^2}{L}
```
while if we separate the gravitational acceleration into a magnitude and unit vector direction, $\vec{g}=g_s \hat{g}$, the nondimensional gravity vector becomes $\vec{g}^\dagger = \hat{g}$. Therefore the nondimensional buoyancy force is

```math
\vec{f}_g^\dagger = \frac{\vec{f}_g}{f_s} = \frac{1}{f_s} \rho_0 \beta (T-T_0)\vec{g} = \frac{\rho_0 g_s \beta_s \Delta T}{\rho_0 U^2/L} \beta^\dagger T^\dagger\hat{g} = \frac{\rm Gr}{{\rm Re}^2} \beta^\dagger T^\dagger \hat{g} = {\rm Ri} \beta^\dagger T^\dagger\hat{g}
```

where ${\rm Gr}=\frac{g_s \beta_s \Delta T L^3}{\nu^2}$ is the Grashof number and ${\rm Ri}=\frac{g_s \beta_s \Delta T L}{U^2}$ is the Richardson number.


## Compatability

Tested with NekRS v25.0-rc1 and v26.0

## Requirements

This case is small enough to run on a single GPU, or a few CPU cores. The OCCA backend can be set in the `.par` file by adding an `[OCCA]` section with `backend = <backend>`; options include `CPU` (or equialently `SERIAL`), `CUDA`, `HIP`, `DPCPP` and `OPENCL`, or passed as an argument to the `nekrs` executable as e.g. `nekrs --backend=cpu`.