# Adding RANS and Periodic BCs

The case builds on `step3_temperature`, using the same heated wall patch, but at higher Reynolds number. A RANS $k-\tau$ model is added, and the case is changed from an inlet-outlet setup driven by the velocity inlet to a periodic domain with a constant flow rate constraint set in `.par`. Additionally, instead of a fixed timestep targeting CFL<0.5, an adaptive timestep is used with a target CFL of 2.5 in `.par`. To ensure the simulation remains stable, subcycling steps are automatically added within the timestepping scheme (in this case, 2 subcycling steps), following the Method of Characteristics.

# Periodic BCs

This case uses the EXODUS mesh generated in `step0_mesh`, but when converting it to `.re2` with `exo2nek` periodic BCs needed to be set up. Follow the steps for using `exo2nek` as in `step0_mesh/README.md`, but set up periodic boundary surface pairs when prompted as follows:

```
 For Fluid domain
 Enter number of periodic boundary surface pairs:
1
 input surface 1 and  surface 2  sideSet ID
1 2
```

The output from this step is as follows:
```
 translation vector:   -1.4884048081537937E-009     3.7393653081109004E-007    -4.9999999999999982
 offset and normalize periodic face coordinates
 bucket sorting to make index of each point
 doing periodic check for surface           1
 doing periodic check for surface           2
 ******************************************************
 Please set boundary conditions to all non-periodic boundaries
 in .usr file usrdat2() subroutine
 ******************************************************
```

This warning refers to a `.usr` file that has not yet been needed. This file is a legacy from Nek5000, used to write Fortran routines to interface with the Nek5000 backend. In this case, a `usrdat2` subroutine is needed to renumber the boundary IDs in the mesh as follows:

| Boundary | Original Boundary ID | New Boundary ID |
| --| -- | -- |
| Inlet | 1 | 0 |
| Outlet | 2 | 0 |
| Walls | 3 | 1 |

This change is needed because boundary ID group 0 is used for boundaries that do not have a BC applied to them (with periodic BCs handled by the setup made during exo2nek rather than needing BCs to be applied to them), so the inlet and outlet must be moved to this group, and `boundaryTypeMap` applies BCs to these boundary groups sequentially starting at ID 1, so not changing the ID of the walls would result in an error. Therefore, in `.par` the only entry in `boundaryTypeMap` for each solve is for the wall boundary.

# RANS $k-\tau$

The RANS $k-\tau$ turbulence model is added using the `RANSktau` plugin built into NekRS. Implementing this model requires adding some functions manually to the `.udf` and `.oudf` files, as well as adding the solvers for the $k$ and $\tau$ fields to the `.par` file. These added sections are clearly marked in these files; it is important to include all these parts to set up the model correctly.
