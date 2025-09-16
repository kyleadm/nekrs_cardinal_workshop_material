#!/bin/bash

# nekRS location
export NEKRS_HOME=$HOME/work/software/cardinal_build/cardinal/install

# run on CPU
# time mpirun -np 16 cardinal-opt -i solid.i

# run on GPU
time mpirun --mca osc ucx -np 1 cardinal-opt --n-threads=16 -i solid.i | tee log.run
