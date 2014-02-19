#!/bin/bash
# 
#PBS -l nodes=arm02.cluster:ppn=1
#PBS -j oe
#PBS -k o

[ -n "$PBS_O_WORKDIR" ] && cd "$PBS_O_WORKDIR"

lmp_ensarm -i lammps.in -var seed $RANDOM

