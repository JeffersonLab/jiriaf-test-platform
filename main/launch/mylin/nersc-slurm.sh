#!/bin/bash

#SBATCH -N 25
#SBATCH -C cpu
#SBATCH -q regular
#SBATCH -J 100g
#SBATCH -t 00:30:00

#run the application:

for i in $(seq 1 25)
do
    i_padded=$(printf "%02d" $i)
    echo $i_padded
    srun -N1 /global/homes/j/jlabtsai/run-vk/slurm/mylin/node-setup.sh $i_padded &
done

wait