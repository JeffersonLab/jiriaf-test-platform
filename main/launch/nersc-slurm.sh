#!/bin/bash

#SBATCH -N 2
#SBATCH -C cpu
#SBATCH -q debug
#SBATCH -J 100g
#SBATCH -t 00:30:00

#run the application:

srun -N1 /global/homes/j/jlabtsai/run-vk/slurm/node1.sh &
srun -N1 /global/homes/j/jlabtsai/run-vk/slurm/node2.sh &

wait