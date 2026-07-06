# Buoyancy: Boussinesq Approximation

Like case 4, this case builds on `step3_temperature`, using the same heated wall patch, but instead of increasing the Reynolds number the temperature of the heated patch is increased and the effect of buoyancy is added through the Boussinesq approximation.

A custom kernel is added to the `.oudf` file, which calculates the buoyancy contribution to the volumetric force. This is used in the `.udf` file, adding a `userSource` function which is set as the `nrs->userSource` volumetric source term in `UDF_Setup`, with the nondimensional gravitational acceleration also defined in `UDF_Setup`.

## Compatability

Tested with NekRS v26.0

## Requirements

This case is small enough to run on a single GPU, or a few CPU cores. The OCCA backend can be set in the `.par` file by adding an `[OCCA]` section with `backend = <backend>`; options include `CPU` (or equialently `SERIAL`), `CUDA`, `HIP`, `DPCPP` and `OPENCL`, or passed as an argument to the `nekrs` executable as e.g. `nekrs --backend=cpu`.