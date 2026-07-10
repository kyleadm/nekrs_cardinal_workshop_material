# NekMHD: Incompressible Inductionless MHD

This case demonstrates the inductionless incompressible MHD capabilities available in an extension to NekRS, known as NekMHD. It should be noted that this capability is not currently available in the main NekRS release, and only a few users have access to the code currently. However, NekMHD is intended for public release in the future.

The example presented covers magnetohydrodynamic flow in a square duct. A magnetic field is applied perpendicular to the flow direction, parallel to two walls (side walls) which are perfect electrical insulators and perpendicular to two walls (Hartmann walls) which are thin but have finite electrical conductivity. This problem has an analytic solution derived by Hunt (Hunt J C R 1965 J. Fluid Mech. 21 577-90), and so is known as a Hunt flow.

In this example, the Hunt case is solved with the inductionless MHD formulation, which assumes induced magnetic fields are negligible. The flow is laminar, with the resulting solution depending mostly on the magnetic field strength (nondimensional parameter: Hartmann number Ha, in this case Ha=20), wall conductivity and thickness, and duct aspect ratio (square in this case).

## Setup

In this case, there are two domains - the fluid domain, and the solid domain. These have each been meshed separately, with the two meshes matching at the fluid-solid interface, and the resulting meshes saved as two separate exodus files. The aim here is to generate a single .re2 file containing both domains, and to set up the boundaries when loaded into NekRS in such a way that the momentum and pressure equations can be solved on the fluid domain only, with BCs set at the inlet, outlet, and fluid-solid interface (but not the exterior walls), while the inductionless equation for electric potential is solved on both the fluid and solid domain, with BCs set at the inlet, outlet and exterior walls (but not the fluid-solid interface).

To do this, we use the approach built into NekRS for the purpose of conjugate heat transfer, where the momentum and pressure equations are solved on the fluid domain only while the energy equation for temperature is solved on both the fluid and solid domains, with the same BC configuration as we use for MHD. Therefore, the instructions below may be useful for users interested in setting up conjugate heat transfer problems entirely within NekRS.

### Converting the mesh

The first step is to use `exo2nek` to convert the two exodus meshes, `fluid.exo` and `solid.exo`, into a single `.re2` file containing both the fluid and solid meshes.

The following sidesets have been defined in the exodus meshes:

| Sideset ID | Name | Mesh file |
| -- | -- | -- |
| 1 | `inlet` | `fluid.exo` |
| 2 | `outlet` | `fluid.exo` |
| 3 | `hartmann_fs_interface` | `fluid.exo` |
| 4 | `side_walls` | `fluid.exo` |
| 5 | `solid_inlet` | `solid.exo` |
| 6 | `solid_outlet` | `solid.exo` |
| 7 | `solid_side_walls` | `solid.exo` |
| 8 | `solid_exterior_walls` | `solid.exo` |

The key entries required to successfully convert these two meshes using `exo2nek` are shown below. A script to do the mesh conversion step is also provided.

```
$ exo2nek
 please input number of fluid exo files:
1
 please input exo file:
fluid
 please input number of solid exo files for CHT problem (input 0 for no solid mesh):
1
 please input exo file:
solid
 For Fluid domain
 Enter number of periodic boundary surface pairs:
0
 please give re2 file name:
channel
```

This results in a .re2 file which contains two domains - the first is the fluid domain as expected, while the second is the combined fluid and solid domain. All 8 boundaries exist in the .re2 file, with all 8 applying to each of the two domains, and by default all 8 must have boundary conditions assigned to them in each `boundaryTypeMap` entry in the `.par` file, however in many cases it is meaningless to assign a boundary condition to these boundaries.

### Boundary assignments at runtime

Boundary assignments can be modified in the `.usr` file, using the `usrdat2` subroutine. In this subroutine, there are four loops, which each loop over the 6 faces of each element. The first loop two loops, one for the fluid domain and one for the fluid+solid domain, check boundary IDs (`boundaryID` for the fluid domain and `boundaryIDt` for the fluid+solid "temperature" domain) and set the type of the boundary to a value, `'i  '` for an inlet, `'o  '` for an outlet, `'W  '` for a wall and `'E  '` for a boundary at which no BC is applied.

While these types have meaning within the nek5000 backend, in this case they are used as tags for reassigning boundary IDs in the last two loops. These loops 

At this stage, the boundary IDs for each domain are as follows:

Fluid domain:

| `boundaryID` | Original Sideset Name(s) | Original Sideset ID(s) |
| -- | -- | -- |
| 1 | `inlet` | 1 |
| 2 | `outlet` | 2 |
| 3 | `hartmann_fs_interface`, `side_walls` | 3, 4 |

Fluid + Solid ("temperature") domain:

| `boundaryIDt` | Name | Original Sideset ID |
| -- | -- | -- |
| 1 | `inlet`, `solid_inlet` | 1, 5 |
| 2 | `outlet`, `solid_outlet` | 2, 6 |
| 3 | `side_walls`, `solid_side_walls`, `solid_exterior_walls` | 4, 7, 8 |

All other element faces are assigned `boundaryID=0` and/or `boundaryID=0`, to which no boundary conditions are applied.

In the `.par` file, the `[FLUID VELOCITY]` `boundaryTypeMap` sets the boundary types on `boundaryID={1, 2, 3}` for the hydrodynamic part of the solve. The `[MHD INDUCTIONLESS]` `boundaryTypeMap` sets the boundary types on `boundaryIDt={1, 2, 3}` for the electric potential equation, because that block also specifies `mesh = fluid+solid` and so is solved on both domains.

### MHD problem setup

Other than the boundary assignments, NekMHD cases are set up as any other NekRS case, albeit with some MHD-specific additions. 

The `[MHD INDUCTIONLESS]` block is added to the `.par` file. In addition to setting the domain and boundary conditions as detailed above, the imposed magnetic field is set (as a uniform vector, however this can be modified for nonuniform B-fields in `UDF_Setup`), as well as the conductivity in the fluid and solid and any Lorentz force coefficient required. As for other NekRS cases, these parameters are generally used to set the nondimensional equivalents. Additionally, the electric potential `Phi` is initialisded in `.udf`, and in some cases additional boundary conditions are set in `.oudf` (for example to set zero-Dirichlet conditions on `Phi` in cases with perfectly conducting walls).

## Compatability

Tested with NekMHD `v26_mhd` branch, commit 47b6a2d51.

## Requirements

This case is small enough to run on a single GPU, or a few CPU cores. The OCCA backend can be set in the `.par` file by adding an `[OCCA]` section with `backend = <backend>`; options include `CPU` (or equialently `SERIAL`), `CUDA`, `HIP`, `DPCPP` and `OPENCL`, or passed as an argument to the `nekrs` executable as e.g. `nekrs --backend=cpu`.