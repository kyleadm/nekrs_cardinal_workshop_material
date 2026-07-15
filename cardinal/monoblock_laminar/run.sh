#!/bin/bash

# Cardinal
export PATH=$PATH:$HOME/work/software/cardinal_v26/cardinal/
export NEKRS_HOME=$HOME/work/software/cardinal_v26/cardinal/install

# run on CPU
# mpirun -np 4 cardinal-opt -i solid.i | tee log.run

# run on GPU
#mpirun -np 1 cardinal-opt --n-threads=4 -i solid.i | tee log.run

# use this command if you have trouble running on GPU
mpirun --mca osc ucx -np 1 cardinal-opt --n-threads=4 -i solid.i | tee log.run
