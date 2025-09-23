# Laminar flow through a monoblock model

This example runs a coupled fluid-solid simulation of laminar flow through a representative monoblock model at Re=100 and Pe=626. The geometry consists of a fluid region of a circular pipe with a diameter of 0.012 [m] and length of 0.1 [m], with flow in the negative z direction. A parabolic inlet profile is used at the inlet (avoiding a sharp transition that would occur at the curve between the inlet and the no-slip walls if a uniform inlet profile was used). It is noted that the fluid solver is run nondimensional with the characteristic length being the pipe diameter. The solid solver runs with dimensional quantities.

The case requires a fluid mesh, stored in `.re2` format, and a solid mesh, stored in `.exo` format. These files are included in the `mesh/` directory along with the `.jou` that generated them. Note that the fluid and solid meshes do not need to be conformal, although for this example they are.

In addition to the NekRS files introduced in the laminar pipe flow example (see `/nekrs/1_pipe_laminar/README.md`), the problem requires two additional files:

- A file for coordinating MOOSE with NekRS (here we call it `nek.i`)  
- A standard MOOSE input file (here we call it `solid.i`).

For more details on setting up a Cardinal simulation see the [online tutorials](https://cardinal.cels.anl.gov/tutorials/cht5.html).

To run the case, ensure you have added the Cardinal directory to your `PATH` and replace the `NEKRS_HOME` environment variable in the `run.sh` script with the location of NekRS in Cardinal and run the script via `./run.sh`.  

If the simulation runs successfully two sets of output files will be generated:  

- **NekRS output:** several `monoblock0.f*` files containing the output results, and a `monoblock.nek5000` file for visualization with ParaView or VisIt.  
- **MOOSE output:** a `solid_out.e` file storing the solid solution.  
- **Cardinal output:** the mirror mesh from Cardinal and corresponding solution data in `solid_out_nek0.e`.  

Running `./clean.sh` will remove the outputs and logs but preserve the `.cache` (allowing you to re-run the simulation with minor changes). For major changes you may need to run `./clean deep` to delete the `.cache`. These scripts are intended as a convenience but are not required for running a case.

## Compatibility

Tested with Cardinal commit `ba183a8d15`.