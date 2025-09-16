#!/bin/bash

ulimit -s unlimited

mpirun -np 4 nekrs --setup coarsePipe.par --backend=cpu 2>&1 | tee log.coarsePipe
mpirun -np 4 nekrs --setup pipe.par --backend=cpu 2>&1 | tee log.pipe
