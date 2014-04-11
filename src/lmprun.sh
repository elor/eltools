#!/bin/bash
# 
#PBS -l nodes=1:ppn=1
#PBS -N lammps-serial
#PBS -m a
#PBS -j oe

[ -n "$PBS_O_WORKDIR" ] && cd "$PBS_O_WORKDIR"

module unload app/lammps-17Dec13/mvapich2-2.0b-gcc-4.8.2 
module load app/lammps-17Dec13/gcc-4.8.2

lammps -nocite -i lammps.in -var seed $RANDOM

