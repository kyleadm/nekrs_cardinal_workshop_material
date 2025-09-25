# Basic laminar pipe flow

This case uses the `.re2` mesh generated in `step0_mesh` (this file is also included here).

This example runs a nondimensionalised simulation of a laminar pipe flow at Re=100 (set using viscosity=1/Re). The geometry is the fluid region of a circular pipe with a diameter of 1 and length of 5, with flow in the negative z direction. A parabolic inlet profile is used at the inlet (avoiding a sharp transition that would occur at the curve between the inlet and the no-slip walls if a uniform inlet profile was used).

The `.par` (parameters) file contains the general settings for the case, including the polynomial order, time stepping, write controls, the mesh, fluid parameters, tolerances, and boundary conditions. As this case is set up to be dimensionless, the `viscosity` parameter actually represents the inverse of the Reynolds number, with the minus sign being interpreted by NekRS as setting the viscosity to be the inverse of the number following the sign. The `[CASEDATA]` block sets parameters which are used in custom functions in the .udf file, setting the average velocity across the inlet, the pipe radius, x and y coordinates of the central axis (all used in the parabolic inlet profile calculation). Additional information about the `.par` file can be found by running `nekrs --help par` with the NekRS environment active.

The `.udf` (user-defined functions) file is used to read parameters from `[CASEDATA]` (in `UDF_Setup0`) and pass them to the occa kernels (in `UDF_LoadKernels`). It also adds in the `.oudf` file using an `#include` directive (alternatively the contents of `.oudf` can simply be given in the `.udf` file in place of the `#include` directive, between the ).

The `.oudf` (OCCA/OKL user-defined functions) file is used to set values for boundary conditions, which must be done on the device. The `boundaryTypeMap` for the velocity solve in the `.par` file sets boundary 1 as an inlet (Dirichlet velocity, zero Neumann pressure), boundary 2 as an outlet (zero Neumann velocity, Dirichlet pressure) and boundary 3 as a wall (zero Dirichlet velocity, zero Neumann pressure). In this case, values for the Dirichlet conditions need to be set, at the inlet for velocity and at the outlet for pressure. The `udfDirichlet` function is used to set these, and applies to all boundaries where these conditions are set for these fields. The different fields are distinguished by evaluating `isField("fluid velocity")` and `isField("pressure velocity")`. For the velocity Dirichlet condition, `bc->{uxFluid,uyFluid,uzFluid}` is used in this case to set the parabolic inlet profile. For the pressure Dirichlet condition, the pressure `bc->pFluid` is set to zero.

To run the case, ensure the NekRS environment is active and run NekRS (see `./run.sh` for an example of how to do this); if the simulation runs successfully several `pipe0.f*` files will be created, containing the output results, and a `pipe.nek5000` file which allows visualisation tools such as ParaView or VisIt to read the outputs. Running `./clean.sh` will remove the outputs and logs but preserve the `.cache` (allowing you to re-run the simulation with minor changes), though if major changes are made you may need to run `./clean_all` to delete the `.cache`. Note that these scripts are intended to help the user, and are not required for running a case.

## Compatability

Tested with NekRS v25.0-rc1

## Requirements

This case is small enough to run on a single GPU, or a few CPU cores. The OCCA backend can be set in the `.par` file by adding an `[OCCA]` section with `backend = <backend>`; options include `CPU` (or equialently `SERIAL`), `CUDA`, `HIP`, `DPCPP` and `OPENCL`, or passed as an argument to the `nekrs` executable as e.g. `nekrs --backend=cpu`.