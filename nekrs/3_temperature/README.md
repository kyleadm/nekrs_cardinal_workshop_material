# Adding the energy equation: solving for temperature

This case demonstrates the extra steps needed to add the energy equation to the system solved by NekRS to solve for temperature in the fluid. A small part of the wall is fixed at a higher temperature than the fluid, heating the passing fluid.

The same (fluid-only) mesh is used for this case as for the previous cases. NekRS can also solve for temperature in a coupled solid domain; this is not demonstrated in this tutorial, but the `nekRS/examples/conj_ht` example would be a good starting point.

The extra equation is set up by adding the `[SCALAR TEMPERATURE]` block to the `.par` file. Initialisation for the temperature field is added to the coded initial condition in `UDF_Setup`, and boundary conditions are coded in the `.oudf` file, setting the inflow temperature as the BC on both the inlet and the wall, except for a small hot patch on the wall.


## Energy equation & nondimensionalisation

Treating temperature $T$ as a passive scalar, the energy equation is

```math
\rho c_p \left( \frac{\partial T}{\partial t} + \vec{u}\cdot \vec{\nabla} T \right) = \vec{\nabla}\cdot\left( \kappa \vec{\nabla} T \right) + \dot{q}
```

where $c_p$ is the specific heat capacity, $\kappa$ is the thermal conductivity and $\dot{q}$ is a volumetric heat source. To nondimensionalise this,

```math
\quad T^\dagger = \frac{T-T_0}{\Delta T}, \quad \kappa^\dagger = \frac{\kappa}{\kappa_0}, \quad \dot{q}^\dagger = \frac{\dot{q}}{q_s}, \quad c_p^\dagger=\frac{c_p}{c_{p_0}}
```

such that

```math
\rho^\dagger c_p^\dagger \left( \frac{\partial T^\dagger}{\partial t^\dagger} + \vec{u}^\dagger \cdot \vec{\nabla}^\dagger T^\dagger \right) = \frac{1}{Pe}\vec{\nabla}^\dagger\cdot\left( \kappa^\dagger \vec{\nabla} T^\dagger \right) + \dot{q}^\dagger
```

where ${\rm Pe} = \frac{\rho_0 c_{p_0}U L}{\kappa_0}$ and it has been assumed that the heat source is scaled by $q_s = \frac{\rho_0 c_{p_0}U \Delta T}{L}$.

Instead of applying a volumetric heat source as shown above, surface heating can be applied as a Neumann boundary condition. Consider Fourier's law of heat conduction for a heat flux $\vec{q''}$, and apply this to a surface

```math
\vec{q''}=-\kappa \vec{\nabla}T \quad \therefore \quad \vec{q''}\cdot\hat{n}=-\kappa\vec{\nabla}T\cdot \hat{n}
```

Taking only the normal component $q''_n=\vec{q''}\cdot\hat{n}$, this can be nondimensionalised, resulting in

```math
\frac{q''_s L}{\kappa_0 \Delta T} {q''_n}^\dagger =-\kappa^\dagger \vec{\nabla}^\dagger T^\dagger\cdot \hat{n}
```

This term arises when the diffusion term of the energy equation is transformed into weak form.

```math
\frac{1}{\rm Pe}\vec{\nabla}^\dagger\cdot\left( \kappa^\dagger \vec{\nabla} T^\dagger \right) \rightarrow \frac{1}{\rm Pe} \left\{ \oint_{\partial \Omega} \psi \kappa^\dagger \vec{\nabla}^\dagger T^\dagger\cdot \hat{n} -\int_{\Omega} (\vec{\nabla}^\dagger \psi) \cdot (\vec{\nabla}^\dagger T^\dagger) \right\}
```

Therefore, the boundary condition should also be scaled by the Peclet number

```math
\frac{1}{\rm Pe}\frac{q''_s L}{\kappa_0 \Delta T} {q''_n}^\dagger =-\frac{1}{\rm Pe}\kappa^\dagger \vec{\nabla}^\dagger T^\dagger\cdot \hat{n}
```

so the scaling for heat flux is

```math
q''_s={\rm Pe}\frac{\kappa_0\Delta}{L} = \frac{\rho_0 c_{p_0}U L}{\kappa_0}\frac{\kappa_0\Delta T}{L} = {\rho_0 {c_p}_0 U \Delta T}
```

## Compatability

Tested with NekRS v25.0-rc1 and v26.0

## Requirements

This case is small enough to run on a single GPU, or a few CPU cores. The OCCA backend can be set in the `.par` file by adding an `[OCCA]` section with `backend = <backend>`; options include `CPU` (or equialently `SERIAL`), `CUDA`, `HIP`, `DPCPP` and `OPENCL`, or passed as an argument to the `nekrs` executable as e.g. `nekrs --backend=cpu`.
