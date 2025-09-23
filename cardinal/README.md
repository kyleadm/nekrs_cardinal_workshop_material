# Examples of Conjugate Heat Transfer using Cardinal

## Geometry

The geometry consists of a fluid region of a circular pipe with a diameter of 0.012 m and length of 0.1 m, with flow in the negative z direction. The solid region consists of two parts: (i) the outer pipe region, which encompasses the fluid domain, and (ii) the armour block region. In all examples, the fluid solver is run in nondimensional form with the characteristic length being the pipe diameter, while the solid solver runs with dimensional quantities.

## Case #1: Laminar flow through a monoblock model using FFTB

Here we demonstrate how to set up a conjugate heat transfer simulation in Cardinal, employing the Flux-Forward Temperature-Backward (FFTB) boundary coupling, for laminar flow through the representative monoblock model. This example runs with flow conditions of Re=100 and Pe=626.

## Case #2: RANS flow through a monoblock model using hFTB

Here we demonstrate how to set up a conjugate heat transfer simulation in Cardinal, employing the Heat-Transfer-Coefficient-Forward Temperature-Backward (hFTB) boundary coupling, for turbulent flow modeled with a Reynolds-Averaged Navier–Stokes (RANS) turbulence model through the representative monoblock model. This example runs with flow conditions of Re=10000 and Pe=62600. We also show how to store MOOSE checkpoints for later restarting a simulation.

## Case #3: LES flow through a monoblock model using FFTB

Here we demonstrate how to set up a conjugate heat transfer simulation in Cardinal, employing the Flux-Forward Temperature-Backward (FFTB) boundary coupling, for turbulent flow modeled with a Large-Eddy Simulation (LES) turbulence model through the representative monoblock model. This example runs with flow conditions of Re=10000 and Pe=62600. We also show how to start the simulation using the solid solution from Case #2 as an initial condition.

## General Setup Information

All cases require a fluid mesh, stored in `.re2` format, and a solid mesh, stored in `.exo` format. These files are included in each of the examples `mesh/` directory along with the `.jou` file that generated them. Note that the fluid and solid meshes do not need to be conformal, although for these examples they are.

In addition to the NekRS files introduced in the laminar pipe flow example (see `/nekrs/1_pipe_laminar/README.md`), the problem requires two additional files:

- A file for coordinating MOOSE with NekRS (here called `nek.i`)  
- A standard MOOSE input file (here called `solid.i`).

For more details on setting up a Cardinal simulation, see the [online tutorials](https://cardinal.cels.anl.gov/tutorials/cht5.html).

To run the case, ensure you have added the Cardinal directory to your `PATH`. Replace the `NEKRS_HOME` environment variable in the `run.sh` script with the location of NekRS in Cardinal, and run the script via `./run.sh`.

If the simulation runs successfully, three sets of output files will be generated:  

- **NekRS output:** several `monoblock0.f*` files containing the output results, and a `monoblock.nek5000` file for visualization with ParaView or VisIt.  
- **MOOSE output:** a `solid_out.e` file storing the solid solution.  
- **Cardinal output:** the mirror mesh from Cardinal and corresponding solution data in `solid_out_nek0.e`.  

Running `./clean.sh` will remove the outputs and logs but preserve the `.cache` (allowing you to re-run the simulation with minor changes). For major changes you may need to run `./clean deep` to delete the `.cache`. These scripts are provided as a convenience but are not required to run a case.

## Compatibility

Tested with Cardinal commit `ba183a8d15`.
