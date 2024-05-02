#!/bin/bash

#SBATCH -N 1
#SBATCH -C cpu
#SBATCH -q debug
#SBATCH -J 100g
#SBATCH -t 00:30:00

#run the application:

for i in $(seq 1)
do
    srun -N1 /global/homes/j/jlabtsai/run-vk/slurm/mylin/node-setup.sh $i &
done

wait