#!/bin/bash
# 
#PBS -l nodes=1:ppn=16
#PBS -j oe
#PBS -k o

[ -n "$PBS_O_WORKDIR" ] && cd "$PBS_O_WORKDIR"

mpirun lmp_ensreich -i lammps.in -var seed $RANDOM

