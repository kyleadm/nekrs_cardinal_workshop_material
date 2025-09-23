#!/bin/bash

# run on CPU
# mpirun -np 4 cardinal-opt -i solid.i | tee log.run

# run on GPU
mpirun -np 1 cardinal-opt --n-threads=4 -i solid.i | tee log.run

# use this command if you have trouble running on GPU
# mpirun --mca osc ucx -np 1 cardinal-opt --n-threads=4 -i solid.i | tee log.run
