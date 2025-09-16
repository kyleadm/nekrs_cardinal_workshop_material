# Adding the energy equation: solving for temperature

This case demonstrates the extra steps needed to add the energy equation to the system solved by NekRS to solve for temperature in the fluid. A small part of the wall is fixed at a higher temperature than the fluid, heating the passing fluid.

The same (fluid-only) mesh is used for this case as for the previous cases. NekRS can also solve for temperature in a coupled solid domain; this is not demonstrated in this tutorial, but the `nekRS/examples/conj_ht` example would be a good starting point.

The extra equation is set up by adding the `[TEMPERATURE]` block to the `.par` file. Initialisation for the temperature field is added to the coded initial condition in `UDF_Setup`, and boundary conditions are coded in the `.oudf` file, setting the inflow temperature as the BC on both the inlet and the wall, except for a small hot patch on the wall.

## Compatability

Tested with NekRS v23.0

## Requirements

This case is small enough to run on a single GPU, or a few CPU cores. The OCCA backend can be set in the `.par` file by adding an `[OCCA]` section with `backend = <backend>`; options include `CPU` (or equialently `SERIAL`), `CUDA`, `HIP`, `DPCPP` and `OPENCL`, or passed as an argument to the `nekrs` executable as e.g. `nekrs --backend=cpu`.