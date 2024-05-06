#!/bin/bash

#SBATCH -N 25
#SBATCH -C cpu
#SBATCH -q regular
#SBATCH -J 100g
#SBATCH -t 01:00:00

#run the application:

for i in $(seq 1 30)
do
    i_padded=$(printf "%02d" $i)
    echo $i_padded
    srun -N1 /global/homes/j/jlabtsai/run-vk/slurm/mylin/node-setup.sh $i_padded &
    sleep 3
done

wait