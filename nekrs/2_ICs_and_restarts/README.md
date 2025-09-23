# Initial conditions and restarts

This example runs the same case set up in `step1_pipe_laminar`, but starts the simulation from either a specified initial condition or by restarting from a previous solution.

## Coded initial condition

An initial condition can be set in the `.udf` file, using the `UDF_Setup` function. This is called during initialisation, before timestepping begins. A parabolic velocity profile (the same used as the inlet boundary condition) is used as the initial condition for velocity, and a user-specified value for the mean velocity (averaged over the cross-sectional area) is taken from `[CASEDATA]` in the `.par` file.

The case can be run using an initial condition by running the `pipe.par` case. Note that there is an intentional mistake in the initial condition, to clearly demonstrate the code switching between the two methods used in this tutorial for setting initial conditions.

## Restarting from a previous solution

Any NekRS case can be easily restarted from a previous solution that used the same `.re2` mesh, by specifying the name of the file to load as the initial condition in the `[GENERAL]` block of the `.re2` file, for example as `startFrom = "coarsePipe0.f00001"`.

A second `.par` file is included, `coarsePipe.par`, which uses the same `.udf`, `.oudf` and `.re2` files as `pipe.par`, but runs the case for a few timesteps with `polynomialOrder = 1`. This will output a solution file `coarsePipe0.f00001`, which can be used as the initial condition for `pipe.par` by adding `startFrom = "coarsePipe0.f00001"` to the `[GENERAL]` block. The `pipe.par` case runs with `polynomialOrder = 3`, with the solution from the lower polynomial order simulation interpolated onto the higher order elements of this simulation. This is known as p-refinement, and is a useful feature, for example for generating coarse initial solutions as demonstrated here or for exploring how the solution develops as the mesh is refined.

A second mesh using the same geometry, `pipe2.re2`, is also included in this case. It is possible to restart a case with a different `.re2` mesh than the original solution used; to do so, add `+int` to the `startFrom` line, e.g. `startFrom = "coarsePipe0.f00001+int"`. In this case, the solution is interpolated between mesh points, rather than between GLL points within the same geometry.

The order of operations is important to consider here - when NekRS initialises the case, restart files are read _before_ `UDF_Setup` is called; if care is not taken to set up the initial condition properly, a coded initial condition would therefore overwrite the solution from the restart file. This is resolved by only setting the coded initial condition if a restart file is not set:

```
void UDF_Setup(nrs_t* nrs)
{
  // Set initial conditions unless a restart file is being used
  if (platform->options.getArgs("RESTART FILE NAME").empty()){
    // code for setting IC ...
  }
}
```

Note that if restarting a case with the same name as the file used for the restart (e.g., running `pipe.par` and restarting from `pipe0.f00005`), the original file will be overwritten when an output file with the same name is created. Therefore, it can often be helpful to rename the solution file used for the restart; a common convention is to name this `u.fld`.

## Compatability

Tested with NekRS v23.0

## Requirements

This case is small enough to run on a single GPU, or a few CPU cores. The OCCA backend can be set in the `.par` file by adding an `[OCCA]` section with `backend = <backend>`; options include `CPU` (or equialently `SERIAL`), `CUDA`, `HIP`, `DPCPP` and `OPENCL`, or passed as an argument to the `nekrs` executable as e.g. `nekrs --backend=cpu`.